//
//  PhotoDetailsViewController.swift
//  Flodel
//
//  Created by Mohammed Iskandar on 02/12/2020.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    var photoView: UIImageView!
    var likesCountLabel: UILabel?
    var detailsLabel: UILabel?
    var titleLabel: UILabel?
    
    var photo: Photo!
    var photoService: PhotoService!
    var imageFetcher: ImageFetcher!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.view.backgroundColor = .systemBackground
        
        self.photoView = UIImageView()
        self.view.addSubview(photoView)
        photoView.contentMode = .scaleAspectFit
        photoView.setConstraints([
            .horizontal(padding: 15),
            .vertical(padding: 15)
        ])
        
        configureView()
    }
    
    func configureView() {
        let distance: String
        if photo.distance > 1 {
            distance = "\(Int(photo.distance.rounded()))km"
        } else {
            distance = "\(Int((photo.distance * 1000).rounded()))m"
        }
        self.detailsLabel?.text = "\(photo.dateTaken.fromNow()), \(distance)"
        self.titleLabel?.text = photo.title?.isEmpty ?? true ? "<<unkown>>" : photo.title
        
        self.photoService.fetchImage(for: photo, cached: {
            image in
            self.photoView?.image = image
        }) {
            [weak self] result in
            
            guard let self = self else { return }
            
            if case let .success(image) = result {
                self.photoView?.image = image
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}
