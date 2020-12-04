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
