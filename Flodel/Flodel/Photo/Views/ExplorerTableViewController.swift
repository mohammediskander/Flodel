//
//  ExplorerTableView.swift
//  Flodel
//
//  Created by Mohammed Iskandar on 02/12/2020.
//

import UIKit

class ExplorerTableViewController: UITableViewController {
    var photoService: PhotoService!
    
    override func viewDidLoad() {
        self.tableView.dataSource = self.photoService
        photoService.delegate = self
    }
}

extension ExplorerTableViewController: PhotoServiceDelegate {
    func photosLoaded() {
        self.tableView.reloadData()
    }
}
