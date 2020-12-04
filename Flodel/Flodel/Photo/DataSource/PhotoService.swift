//
//  PhotoService.swift
//  Flodel
//
//  Created by Mohammed Iskandar on 02/12/2020.
//

import UIKit

protocol PhotoServiceDelegate: AnyObject {
    func photosLoaded()
}

enum PhotoError: Error {
    case imageCreationError
    case missingImageURL
    case missingPhotoID
}

class PhotoService: NSObject {
    
    private let imageStore = ImageStore()
    private var requests: [IndexPath: ImageFetchingRequest] = [:]
    private let imageFetcher = ImageFetcher()
    
    weak var delegate: PhotoServiceDelegate?
    typealias PhotoResult = Result<[Photo], Error>
    typealias ImageResult = Result<UIImage, Error>
    
    var photos: [Photo] = [] {
        didSet {
            if photos != oldValue {
                self.delegate?.photosLoaded()
            }
        }
    }
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    override init() {
        super.init()
        
        self.fetchPhotos()
    }
    
    @objc func handleMemoryWarning(_ notification: Notification) -> Void {
        
    }
    
    func fetchPhotos(_ completion: @escaping () -> Void = { }) {
        let latitude = UserDefaults.standard.double(forKey: "user.currentLocation.latitude")
        let longitude = UserDefaults.standard.double(forKey: "user.currentLocation.longitude")
        
        self.getPhotos(at: (latitude: latitude, longitude: longitude)) {
            result in
            
            switch result {
            case let .success(photos):
                self.photos = photos.sorted(by: { lhs, rhs -> Bool in lhs.distance < rhs.distance })
                completion()
            case let .failure(error):
                print("ERR::\(error)")
            }
        }
    }
    
    func getPhotos(at coordinates: (latitude: Double, longitude: Double), completion: @escaping (PhotoResult) -> Void) {
        do {
            let urlRequest = try PhotoRouter.photosSearch(latitude: coordinates.latitude, longitude: coordinates.longitude).asURLRequest()
            
            let task = self.session.dataTask(with: urlRequest) {
                data, response, error in
                
                let result = self.processPhotos(data: data, error: error)
                
                OperationQueue.main.addOperation {
                    completion(result)
                }
            }
            
            task.resume()
        } catch {
            print("ERR::\(error)")
        }
    }
    
    func processPhotos(data: Data?, error: Error?) -> PhotoResult {
        do {
            let decoder = JSONDecoder()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let photosResponse = try decoder.decode(PhotosResponse.self, from: data!)
            let filteredPhotos = photosResponse.photosInfo.photos.filter { $0.remoteURL != nil }
            
            return .success(filteredPhotos)
        } catch {
            print("ERR::\(error)")
            return .failure(error)
        }
    }
    
//    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {
//        guard let photoKey = photo._id else {
//            completion(.failure(PhotoError.missingPhotoID))
//            return
//        }
//        
//        if let image = imageStore.image(forKey: photoKey) {
//            OperationQueue.main.addOperation {
//                completion(.success(image))
//            }
//        }
//        
//        guard let photoURL = photo.remoteURL else {
//            completion(.failure(PhotoError.missingImageURL))
//            return
//        }
//        
//        let request = URLRequest(url: photoURL)
//        
//        let task = session.dataTask(with: request) {
//            data, repsonse, error in
//            
//            let result = self.processImageRequest(data: data, error: error)
//            
//            if case let .success(image) = result {
//                self.imageStore.setImage(image, forKey: photoKey)
//            }
//            
//            OperationQueue.main.addOperation {
//                completion(result)
//            }
//        }
//        
//        task.resume()
//    }
    
    private func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        guard let imageData = data, let image = UIImage(data: imageData) else {
            if data == nil {
                return .failure(error!)
            } else {
                return .failure(PhotoError.imageCreationError)
            }
        }
        
        return .success(image)
    }
}

extension PhotoService: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.photos.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let photo = self.photos[indexPath.section]
        // First, check the image cache
        if let photoId = photo._id, let image = imageStore.image(forKey: photoId), let cell = cell as? ExplorerCell {
            cell.update(displaying: image)
        }
        
        // Second, check to see if we've already requested an image for this cell
        // and if so, just upgrade its priority
        if let request = requests[indexPath] {
            request.priority = .high
            return
        }
        
        let request = self.imageFetcher.fetch(url: photo.remoteURL!, priority: .high) {
            result in
            
            let image: UIImage?
            switch result {
            case let .success(fetchedImage):
                image = fetchedImage
            case let .failure(error):
                let photoId = photo._id ?? "<<unkown>>"
                
                switch error {
                case ImageFetcher.Error.canceled:
                    print("Cancelled fetching photo \(photoId)")
                default:
                    print("Failed to fetch photo with id \(photoId): \(error)")
                }
                
                image = nil
            }
            
            guard let fetchedImage = image else { return }
            guard let photoIndex = self.photos.firstIndex(of: photo) else { return }
            
            let photoIndexPath = IndexPath(row: 0, section: photoIndex)
            
            OperationQueue.main.addOperation {
                if let photoId = photo._id {
                    self.imageStore.setImage(fetchedImage, forKey: photoId)
                }
                
                // When the request finished, only update the cell if it's still visible
                if let cell = tableView.cellForRow(at: photoIndexPath) as? ExplorerCell {
                    cell.update(displaying: image)
                }
                
                // Stop tracking the request once it's complete
                self.requests[indexPath] = nil
            }
        }
        
        // Start tracking the request right after creating it..
        OperationQueue.main.addOperation {
            self.requests[indexPath] = request
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        requests[indexPath]?.priority = .low
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "explorerPhoto") as? ExplorerCell
        
        cell?.photo = self.photos[indexPath.section]
        
        return cell!
    }
}

struct PhotosResponse: Codable {
    let photosInfo: FlickrPhotosResponse
    
    enum CodingKeys: String, CodingKey {
        case photosInfo = "photos"
    }
}

struct FlickrPhotosResponse: Codable {
    let photos: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case photos = "photo"
    }
}
