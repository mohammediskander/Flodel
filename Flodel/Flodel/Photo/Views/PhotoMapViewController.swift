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
            photoAnnotation.photo = photo
            
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
                    print("\(#function) ERR::Failed to fetch an image with an id of \(String(describing: photo._id)).", error)
                }
            }
            
            let pinAnnotationView = MKPinAnnotationView(annotation: photoAnnotation, reuseIdentifier: "photoAnnotation")
            self.mapView.addAnnotation(pinAnnotationView.annotation!)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.selectedAnnotations.removeAll()
        if view.reuseIdentifier == "photoAnnotation" {
            let photoDetailsViewController = PhotoDetailsViewController()
            guard let photoAnnotation = view.annotation as? PhotoAnnotation else { return }
            
            photoDetailsViewController.photo = photoAnnotation.photo
            photoDetailsViewController.photoService = photoService

            self.present(photoDetailsViewController, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        let reuseIdentifier = "photoAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? PhotoAnnotationView

        if annotationView == nil {
            annotationView = PhotoAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.displayPriority = .defaultHigh
        
        
        if let customPointAnnotation = annotation as? PhotoAnnotation {
            annotationView?.photoImage = customPointAnnotation.image
        }

        return annotationView
    }
}
