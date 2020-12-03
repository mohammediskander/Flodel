//
//  ExplorerCell.swift
//  Flodel
//
//  Created by Mohammed Iskandar on 02/12/2020.
//

import UIKit

class ExplorerCell: UITableViewCell {
    @IBOutlet var photoDetails: UILabel!
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var photo: Photo! {
        didSet {
            self.configureCell()
        }
    }
    
    func configureCell() {
        update(displaying: nil)
        var distance: String?
        if photo.distance > 1 {
            distance = "\(Int(photo.distance.rounded()))km"
        } else {
            distance = "\(Int((photo.distance * 1000).rounded()))m"
        }
        
        self.photoDetails.text = "\(self.photo.dateTaken.fromNow()), \(distance!) away"
        
        self.photoDetails.layer.shadowColor = UIColor.black.cgColor
        self.photoDetails.layer.shadowOffset = .zero
        self.photoDetails.layer.shadowRadius = 1
        self.photoDetails.layer.shadowOpacity = 1
    }
    
    func update(displaying image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            spinner.isHidden = true
            cellImage.image = imageToDisplay
        } else {
            spinner.isHidden = false
            spinner.startAnimating()
            cellImage.image = nil
        }
    }
}

extension Date {
    func fromNow() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
