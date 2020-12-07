//
//  ImageFetchRequest.swift
//  Flodel
//
//  Created by Mohammed Iskandar on 04/12/2020.
//

import Foundation

class ImageFetchingRequest {
    private var operation: ImageFetchingOperation
    private let queue: OperationQueue
    
    var priority: ImageFetcher.Priority = .low {
        didSet(oldPriority) {
            guard priority != oldPriority else { return }
            guard !operation.isExecuting else { return }
            
            let newOperation = ImageFetchingOperation(operation: operation, priority: priority)
            
            operation.cancel()
            operation = newOperation
            queue.addOperation(newOperation)
        }
    }
    
    init(operation: ImageFetchingOperation, queue: OperationQueue) {
        self.operation = operation
        self.queue = queue
    }
    
    func cancel() {
        operation.cancel()
    }
}
