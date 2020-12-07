//
//  FlickrConstants.swift
//  FlodelTests
//
//  Created by Mohammed Iskandar on 07/12/2020.
//

import Foundation
@testable import Flodel

class FlickrConstants {
    static let requiredParams: Parameters = [
        "extras": "url_l,geo,date_taken,date_upload,owner_name",
        "api_key": "a6d819499131071f158fd740860a5a88",
        "method": "flickr.photos.search",
        "format": "json",
        "nojsoncallback": "1",
        "per_page": "20",
        "lat": "0.0",
        "lon": "0.0",
        "page": "1",
        "sort": PhotosSort.newest.rawValue,
        "accuracy": "11"
    ]
    
    static let flickrHttpMethod = HTTPMethod.get
}
