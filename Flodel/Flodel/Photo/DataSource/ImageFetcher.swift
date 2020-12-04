//
//  ImageFetcher.swift
//  Flodel
//
//  Created by Mohammed Iskandar on 04/12/2020.
//

import UIKit

class ImageFetcher {
    
    enum Error: Swift.Error {
        case canceled
    }
    
    enum Priority {
        case high
        case low
    }
    
    typealias ResultHandler = (Result<UIImage, Swift.Error>) -> Void
    
    private let fetchingQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        return queue
    }()
    
    @discardableResult
    func fetch(url: URL, priority: ImageFetcher.Priority, completion: @escaping ResultHandler) -> ImageFetchingRequest {
//        let imageOperation = ImageFetchingOperation(url: URL, priority: Priority, completion: completion)
//        let request = ImageFetchingRequest(operation: imageOperation, queue: fetchingQueue)
        
        let imageOperation = ImageFetchingOperation(url: url, priority: priority, completion: completion)
        
        let request = ImageFetchingRequest(operation: imageOperation, queue: fetchingQueue)
        
        return request
    }
}
