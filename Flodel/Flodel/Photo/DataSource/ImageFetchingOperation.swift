//
//  ImageFetchOperation.swift
//  Flodel
//
//  Created by Mohammed Iskandar on 04/12/2020.
//

import UIKit

class ImageFetchingOperation: Operation {
    var url: URL?
    let completion: ImageFetcher.ResultHandler
    
    typealias ImageResult = Result<UIImage, Error>
    
    init(url: URL, priority: ImageFetcher.Priority = .low, completion: @escaping ImageFetcher.ResultHandler) {
        self.url = url
        self.completion = completion
        
        super.init()
        
        switch priority {
        case .high:
            qualityOfService = .userInitiated
            queuePriority = .high
        case .low:
            qualityOfService = .utility
            queuePriority = .low
        }
    }
    
    convenience init(operation: ImageFetchingOperation, priority: ImageFetcher.Priority = .low) {
        guard let url = operation.url else {
            preconditionFailure("FETAL: Attempt to clone an operation with nil url.")
        }
        
        self.init(url: url, priority: priority, completion: operation.completion)
    }
    
    override func cancel() {
        super.cancel()
        url = nil
    }
    
    override func main() {
        guard let url = url else {
            completion(.failure(ImageFetcher.Error.canceled))
            return
        }
        
        do {
            try self.fetch(url) { [weak self]
                result in
                
                guard let self = self else { return }
                
                switch result {
                case let .success(image):
                    self.completion(.success(image))
                case let .failure(error):
                    self.completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetch(_ url: URL, completion: @escaping (ImageResult) -> Void) throws {
        guard !isCancelled else { throw ImageFetcher.Error.canceled }
        
        // Set up the URLRequest and Session
        let session: URLSession = {
            let config = URLSessionConfiguration.default
            return URLSession(configuration: config)
        }()
        let request = URLRequest(url: url)
        
        session.dataTask(with: request) {
            [weak self] data, response, error in
            
            guard let self = self else { return }
            
            let result = self.parseImage(data: data, error: error)
            
            completion(result)
        }.resume()
    }
    
    func parseImage(data: Data?, error: Error?) -> ImageResult {
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
