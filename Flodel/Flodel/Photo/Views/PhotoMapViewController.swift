//
//  PhotoMapViewController.swift
//  Flodel
//
//  Created by Mohammed Iskandar on 03/12/2020.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    var photoService: PhotoService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsScale = true
        mapView.delegate = self
        mapView.showsUserLocation = true
//        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        showPhotosOnMap()
        print(mapView.annotations.count)
    }
    
    func showPhotosOnMap() {
        self.photoService.photos.forEach {
            photo in
            
//            let photoAnnotation = CustomAnnotation()
//            photoAnnotation.coordinate = photo.coordinate
//            photoAnnotation.title = photo.title
            
            
//            let photoAnnotation = MKAnnotationView
//            let lat = Double(photo.latitude)
//            let long =
//            let annotation = Station(latitude: lat, longitude: long)
//            annotation.title = item.valueForKey("title") as? String
//            annotations.append(photo)
        
//            let pointAnnotation = CustomAnnotation()
//            pointAnnotation.pinCustomImage = nil
//
//            photoService.fetchImage(for: photo) {
//                [weak photoAnnotation, weak photo] result in
//
//                print("is main thread? \(Thread.current == Thread.main)")
//                guard let photoAnnotation = photoAnnotation else { return }
//
//                switch result {
//                case let .success(image):
//                    photoAnnotation.pinCustomImage = image
//                case let .failure(error):
//                    print("ERR::Failed to load an image with id \(String(describing: photo?._id))", error)
//                    break
//                }
//            }
//
//            let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
//            mapView.addAnnotation(pinAnnotationView.annotation!)
//            mapView.addAnnotation(photoAnnotation)
            mapView.addAnnotation(photo)
        }
    }
}

class CustomAnnotation: MKPointAnnotation {
    var pinCustomImage: UIImage!
}

class CustomAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = true
//        update(for: annotation)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 45).isActive = true
        self.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.layer.cornerRadius = 45 / 2
//        self.layer.
        
        let imageView = UIImageView()
        imageView.image = (annotation as? CustomAnnotation)?.pinCustomImage
        self.addSubview(imageView)
    }

//    override var annotation: MKAnnotation?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    private func update(for annotation: MKAnnotation?) {
//        image = (annotation as? CustomAnnotation)?.pinCustomImage
//    }
}
