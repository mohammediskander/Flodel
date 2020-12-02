//
//  URL+URLComponents.swift
//  Flodel
//
//  Created by Mohammed Iskandar on 02/12/2020.
//

import Foundation

extension URL {
    func toURLComponents() -> URLComponents? {
        return URLComponents(url: self, resolvingAgainstBaseURL: false)
    }
    
    mutating func addQueryItems(_ queryItems: [URLQueryItem]) {
        
        var urlComponent = self.toURLComponents()
        urlComponent?.queryItems = queryItems
        
        self = (urlComponent?.url)!
    }
    
    func getQueryItems() -> [URLQueryItem]? {
        return self.toURLComponents()?.queryItems
    }
}
