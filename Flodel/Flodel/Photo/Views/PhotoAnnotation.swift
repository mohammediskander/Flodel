//
//  ImageAnnotation.swift
//  Flodel
//
//  Created by Mohammed Iskandar on 03/12/2020.
//

import UIKit
import MapKit

class PhotoAnnotation: MKPointAnnotation {
    var image: UIImage!
    weak var photo: Photo!
}

class PhotoAnnotationView: MKAnnotationView {
    
    var imageView: UIImageView!
    
    var photoImage: UIImage? {
        didSet {
            imageView.image = photoImage
//            self.image = .none
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.setConstraints([.height(61), .width(61)])
        self.backgroundColor = .white
        self.layer.cornerRadius = 12.5
        imageView = UIImageView()
        self.addSubview(imageView)
        
        imageView.setConstraints([.height(50), .width(50), .center])
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12.5
        imageView.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
