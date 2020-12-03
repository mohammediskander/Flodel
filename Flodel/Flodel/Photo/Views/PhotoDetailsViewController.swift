//
//  PhotoDetailsViewController.swift
//  Flodel
//
//  Created by Mohammed Iskandar on 02/12/2020.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet var photoView: UIImageView!
    @IBOutlet var likesCountLabel: UILabel!
    @IBOutlet var detailsLabel: UILabel!
    
    var photo: Photo!
    var photoService: PhotoService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        configureView()
    }
    
    func configureView() {
        let distance: String
        if photo.distance > 1 {
            distance = "\(Int(photo.distance.rounded()))km"
        } else {
            distance = "\(Int((photo.distance * 1000).rounded()))m"
        }
        self.detailsLabel.text = "\(photo.dateTaken.fromNow()), \(distance)"
        self.photoService.fetchImage(for: photo) {
            [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case let .success(image):
                self.photoView.image = image
            case let .failure(error):
                print("ERR::Failed to fetch an image with id \(String(describing: self.photo._id))", error)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}