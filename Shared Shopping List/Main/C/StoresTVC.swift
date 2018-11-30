//
//  StoresTVC.swift
//  Shared Shopping List
//
//  Created by Admin on 11/30/18.
//  Copyright © 2018 Guest account. All rights reserved.
//

import UIKit

class StoresTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }
}

// MARK: - Table view data source
extension StoresTVC {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: - investigate ! removal options
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! StoreCell
        let cellTitle = stores[indexPath.row].title
        cell.configureCell(title: cellTitle)
        return cell
    }
}


