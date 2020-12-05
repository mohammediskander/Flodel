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
    var photosAnnotations: [PhotoAnnotation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsScale = true
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        
        showAnnotations()
    }
    
    
    
    func showAnnotations() {
        self.photoService.photos.forEach {
            photo in
            let photoAnnotation = PhotoAnnotation()
            photoAnnotation.title = photo.title
            photoAnnotation.coordinate = photo.coordinate
            
//            photoService.fetchImage(for: photo) {
//                [weak photoAnnotation] result in
//
//                guard case let .success(image) = result else { return }
//                guard let photoAnnotation = photoAnnotation else { return }
//
//                photoAnnotation.image = image
//            }
            
            photoService.fetchImage(for: photo, cached: {
                image in
                
                photoAnnotation.image = image
                
            }) {
                result in
                
                switch result {
                case let .success(image):
                    photoAnnotation.image = image
                    
                case let .failure(error):
                    print("ERR::Failed to fetch an image with an id of \(String(describing: photo._id)).", error)
                }
            }
            
            let pinAnnotationView = MKPinAnnotationView(annotation: photoAnnotation, reuseIdentifier: "photoAnnotation")
            self.mapView.addAnnotation(pinAnnotationView.annotation!)
        }
    }
    
    #warning("showUserLocation is being overrinden by photoAnnotation, fix this!")
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "photoAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.layer.cornerRadius = 12.5
        annotationView?.layer.masksToBounds = true
        annotationView?.displayPriority = .defaultHigh
        annotationView?.translatesAutoresizingMaskIntoConstraints = false
        annotationView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        annotationView?.widthAnchor.constraint(equalToConstant: 40).isActive = true

        if let customPointAnnotation = annotation as? PhotoAnnotation {
            annotationView?.image = customPointAnnotation.image
        }

        return annotationView
    }
}
