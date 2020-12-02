//
//  URLRequest+QueryItems.swift
//  Flodel
//
//  Created by Mohammed Iskandar on 02/12/2020.
//

import Foundation

extension URLRequest {
    var queryItems: [URLQueryItem]? {
        set {
            guard let queryItems = newValue else {
                return
            }
            
            self.url?.addQueryItems(queryItems)
        }
        
        get {
            return self.url?.getQueryItems()
        }
    }
}

extension Parameters {
    func toURLQueryItems() -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        
        for param in self {
            queryItems.append(URLQueryItem(name: param.key, value: param.value as? String))
        }
        
        return queryItems
    }
}
