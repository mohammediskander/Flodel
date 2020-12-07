//
//  PhotoViewController.swift
//  Flodel
//
//  Created by Mohammed Iskandar on 02/12/2020.
//

import UIKit
import CoreLocation

class PhotoViewController: UIViewController {
    private let photoService = PhotoService()
    
    @IBOutlet var photosSortSegmentView: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let latitude = UserDefaults.standard.double(forKey: "user.currentLocation.latitude")
        let longitude = UserDefaults.standard.double(forKey: "user.currentLocation.longitude")
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) {
            [weak self] data, error in
            
            guard let self = self else { return }
            guard let placemark = data?.first else {
                guard let error = error else {
                    print("ERR::Unexpected error occure")
                    return
                }
                
                print("ERR::\(error)")
                return
            }
            
            self.title = placemark.locality
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "showExplorerTableView":
            let destination = segue.destination as! ExplorerTableViewController
            
            destination.photoService = self.photoService
        case "showPhotoMapViewController":
            let destination = segue.destination as! PhotoMapViewController
            
            destination.photoService = self.photoService
        default:
            print("\(#function) ERR::Unexpected segue identitifer \(String(describing: segue.identifier)).")
        }
    }
    
    @IBAction func handlePhotosSortSegmentChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            photoService.setSort(by: .newest)
        case 1:
            photoService.setSort(by: .nearest)
        default:
            preconditionFailure("ERR::Unkown segment index")
        }
    }
}
