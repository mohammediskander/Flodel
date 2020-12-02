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
}

class PhotoService: NSObject {
    
    weak var delegate: PhotoServiceDelegate?
    typealias PhotoResult = Result<[Photo], Error>
    
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
    
    func fetchPhotos() {
        let latitude = UserDefaults.standard.double(forKey: "user.currentLocaiton.latitude")
        let longitude = UserDefaults.standard.double(forKey: "user.currentLocaiton.longitude")
        
        self.getPhotos(at: (latitude: latitude, longitude: longitude)) {
            result in
            
            switch result {
            case let .success(photos):
                self.photos = photos.sorted(by: { lhs, rhs -> Bool in lhs.distance < rhs.distance })
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
        } catch {
            print("ERR::\(error)")
        }
    }
    
    func processPhotos(data: Data?, error: Error?) -> PhotoResult {
        do {
            let decoder = JSONDecoder()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-DD HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
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
