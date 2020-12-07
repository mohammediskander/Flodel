//
//  FakeFlickrURLProtocol.swift
//  FlodelTests
//
//  Created by Mohammed Iskandar on 07/12/2020.
//

import Foundation

class FakeFlickrURLProcotol: URLProtocol {
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        print("Vending fake URL response.")
        
        client?.urlProtocol(self, didReceive: Constants.okResponse, cacheStoragePolicy: .notAllowed)
    
        client?.urlProtocol(self, didLoad: Constants.jsonData)
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        print("Done vending fake URL response.")
    }
    
}
