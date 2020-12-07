//
//  PhotoRouter.swift
//  Flodel
//
//  Created by Mohammed Iskandar on 01/12/2020.
//

import Foundation

enum PhotoRouter: Router {
    case photosSearch(latitude: Double, longitude: Double, page: Int, sort: PhotosSort)
    
    static var baseURL: URL? = URL(string: "https://api.flickr.com/services/rest/")
    
    var method: HTTPMethod {
        switch self {
        case .photosSearch:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .photosSearch:
            return "/"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .photosSearch(latitude, longitude, page, sort):
            return [
                "lat": String(latitude),
                "lon": String(longitude),
                "accuracy": "11",
                "extras": "url_l,geo,date_taken,date_upload,owner_name",
                "api_key": "a6d819499131071f158fd740860a5a88",
                "method": "flickr.photos.search",
                "format": "json",
                "nojsoncallback": "1",
                "per_page": "20",
                "page": String(page),
                "sort": sort.rawValue
            ]
        }
    }
    
    var accessType: AccessType? {
        return .publicRoute
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: PhotoRouter.baseURL!)
        
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.addValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.addValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        if let parameters = parameters {
            do {
                if method == .get {
                    urlRequest.queryItems = parameters.toURLQueryItems()
                } else {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                }
            } catch {
                throw ParametersError.encodingError
            }
        }
        
        return urlRequest;
    }
}
