//
//  Constants.swift
//  FlodelTests
//
//  Created by Mohammed Iskandar on 07/12/2020.
//

import Foundation
@testable import Flodel

class Constants {
    
    static let url = PhotoRouter.baseURL!
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }()
    
    static let validPhotosDic: [[String: Any]] = [
        [
            "id": "49482112248",
            "owner": "69885439@N07",
            "secret": "1145e6aca9",
            "server": "65535",
            "farm": 66,
            "title": "IMG_5137",
            "ispublic": 1,
            "isfriend": 0,
            "isfamily": 0,
            "dateupload": "1580734009",
            "datetaken": "2020-02-02 16:44:09",
            "datetakengranularity": "0",
            "datetakenunknown": "0",
            "ownername": "Journey Jeff's Pix",
            "latitude": "24.700950",
            "longitude": "46.692452",
            "accuracy": "14",
            "context": 0,
            "place_id": "zO.3TDlVVrLqS2E",
            "woeid": "448643",
            "geo_is_public": 1,
            "geo_is_contact": 0,
            "geo_is_friend": 0,
            "geo_is_family": 0,
            "url_l": "https://live.staticflickr.com/65535/49482112248_0c5165a83a_o.jpg",
            "height_o": 2448,
            "width_o": 3264
        ],
        [
            "id": "49478444478",
            "owner": "69885439@N07",
            "secret": "5e0939b410",
            "server": "65535",
            "farm": 66,
            "title": "IMG_5120",
            "ispublic": 1,
            "isfriend": 0,
            "isfamily": 0,
            "dateupload": "1580668935",
            "datetaken": "2020-02-01 15:00:33",
            "datetakengranularity": "0",
            "datetakenunknown": "0",
            "ownername": "Journey Jeff's Pix",
            "latitude": "24.700950",
            "longitude": "86.692452",
            "accuracy": "14",
            "context": 0,
            "place_id": "zO.3TDlVVrLqS2E",
            "woeid": "448643",
            "geo_is_public": 1,
            "geo_is_contact": 0,
            "geo_is_friend": 0,
            "geo_is_family": 0,
            "url_l": "https://live.staticflickr.com/65535/49478444478_76415d2466_o.jpg",
            "height_o": 2448,
            "width_o": 3264
        ]
    ]
    
    static func photosDictionary(_ dic: [[String: Any]]) -> [String: Any] {
        return [
            "photos": [
                "page": 2,
                "pages": 63,
                "perpage": 250,
                "total": "15594",
                "photo": dic
            ]
        ]
    }
    
    static let jsonData = try! JSONSerialization.data(withJSONObject: photosDictionary(validPhotosDic))
    
    static let okResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let errorResponse = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
    
    static let sessionConfiguration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [FakeFlickrURLProcotol.self]
        return config
    }()
}
