//
//  PhotoViewController.swift
//  Flodel
//
//  Created by Mohammed Iskandar on 02/12/2020.
//

import UIKit

class PhotoViewController: UIViewController {
    private let photoService = PhotoService()
    
    @IBOutlet var photosSortSegmentView: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = false
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
            print("ERR::Unexpected segue identitifer \(String(describing: segue.identifier)).")
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
