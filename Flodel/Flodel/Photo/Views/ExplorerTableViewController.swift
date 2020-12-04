//
//  ExplorerTableView.swift
//  Flodel
//
//  Created by Mohammed Iskandar on 02/12/2020.
//

import UIKit
import CoreLocation

class ExplorerTableViewController: UITableViewController {
    var photoService: PhotoService!
    
    override func viewDidLoad() {
        self.tableView.dataSource = self.photoService
        photoService.delegate = self
        
        // get user current city..
        self.getPlacemark()
    }
    
    func getPlacemark() {
        
        let latitude = UserDefaults.standard.double(forKey: "user.currentLocation.latitude")
        let longitude = UserDefaults.standard.double(forKey: "user.currentLocation.longitude")
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler:
                                            {
                                                placemarks, error -> Void in
                                                
                                                // Place details
                                                guard let placeMark = placemarks?.first else { return }
                                                
                                                // Location name
                                                if let locationName = placeMark.location {
                                                    print("locationName", locationName)
                                                }
                                                // Street address
                                                if let street = placeMark.thoroughfare {
                                                    print("street", street)
                                                }
                                                // City
                                                if let city = placeMark.subAdministrativeArea {
                                                    print("city", city)
                                                    self.navigationController?.navigationItem.title = city
                                                }
                                                // Zip code
//                                                if let zip = placeMark.isoCountryCode {
//                                                    print(zip)
//                                                }
                                                // Country
                                                if let country = placeMark.country {
                                                    print("country", country)
                                                }
                                            })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPhotoDetails":
            let destination = segue.destination as! PhotoDetailsViewController
            
            destination.photo = photoService.photos[tableView.indexPathForSelectedRow!.section]
            destination.photoService = self.photoService
        default:
            print("ERR::Unexpected segue with identifier \(segue.identifier!)")
        }
    }
    
    
    @IBAction func handleTableViewRefreshRequest(_ sender: UIRefreshControl) {
        self.photoService.fetchPhotos {
            [weak sender] in
            
            guard let sender = sender else {
                return
            }
            sender.endRefreshing()
        }
    }
}

extension ExplorerTableViewController: PhotoServiceDelegate {
    func photosLoaded() {
        self.tableView.reloadData()
    }
}
