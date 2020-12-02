//
//  Photos.swift
//  Flodel
//
//  Created by Mohammed Iskandar on 02/12/2020.
//

import Foundation

class Photo: Equatable, Codable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs._id == rhs._id
    }
    
    let _id: String?
    let title: String
    let remoteURL: URL?
    let dateTaken: Date
    let latitude: String
    let longitude: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case remoteURL = "url_l"
        case _id = "id"
        case dateTaken = "datetaken"
        case latitude
        case longitude
    }
    
    var distance: Double {
        return self.getDistance()
    }
    
    private func getDistance() -> Double {
        let R: Double = 6371 // World Radius in km
        
        let latitude = UserDefaults.standard.double(forKey: "user.currentLocation.latitude")
        let longitude = UserDefaults.standard.double(forKey: "user.currentLocation.longitude")
        
        let phiUserLatitude = Photo.toRadius(latitude) // φ, λ in radians
        let phiPhotoLatitude = Photo.toRadius(Double(self.latitude)!)
        
        let deltaPhi = Photo.toRadius(from: latitude, to: Double(self.latitude)!)
        let deltaLambda = Photo.toRadius(from: longitude, to: Double(self.longitude)!)
        
        // a = sin²(Δφ/2) + cos φ1 ⋅ cos φ2 ⋅ sin²(Δλ/2)
        let a = sin(deltaPhi / 2.0) * sin(deltaPhi / 2.0) + sin(deltaLambda / 2.0) * sin(deltaLambda / 2.0) * cos(phiUserLatitude) * cos(phiPhotoLatitude)
        
        // c = 2 ⋅ atan2( √a, √(1−a) )
        let c = 2.0 * atan2(sqrt(a), sqrt(1.0 - a))
        
        // distance = R * c
        return R * c
    }
    
    private static func toRadius(_ number: Double) -> Double {
        return number * Double.pi / 180
    }
    
    private static func toRadius(from: Double, to: Double) -> Double {
        return self.toRadius(to - from)
    }
}
