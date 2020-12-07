//
//  Image.swift
//  Flodel
//
//  Created by Mohammed Iskandar on 02/12/2020.
//

import UIKit

class ImageStore {
    let cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        // Create full URL for image
        let url = imageURL(forKey: key)
        
        if let data = image.toJPEG(with: .highQuality) {
            // Write it to full URL
            try? data.write(to: url)
        }
    }
    
    func image(forKey key: String) -> UIImage? {
        
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        
        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("\(#function) ERR::An occure while removing image with key \(key) from dist.", error)
        }
    }
    
    func imageURL(forKey key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
    }
}


extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowestQuality  = 0
        case lowQuality     = 0.25
        case mediumQuality  = 0.5
        case highQuality    = 0.75
        case heighstQuality = 1
    }
    
    /// Return the data for the specified image in JPEG format.
    /// if the image object's underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - Parameter quality: The quality of the resulting JPEG image; default is `.mediumQuality`
    /// - Returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func toJPEG(with quality: JPEGQuality = .mediumQuality) -> Data? {
        return self.jpegData(compressionQuality: quality.rawValue)
    }
}
