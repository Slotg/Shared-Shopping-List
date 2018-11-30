//
//  StoresVC.swift
//  Shared Shopping List
//
//  Created by Admin on 11/30/18.
//  Copyright © 2018 Guest account. All rights reserved.
//

import UIKit

class StoresVC: UIViewController {

    var tableView: UITableView?
    // MARK: - IBActions
    @IBAction func btnActionAddStore(_ sender: Any) {
        presentCreateSroreAlert()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = (childViewControllers.last as? UITableViewController)?.tableView
    }
}

//MARK: - Add Store
extension StoresVC {
    func presentCreateSroreAlert() {
        let alert = UIAlertController(title: "Enter Store name", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Store name"
        }
        let createStore = UIAlertAction(title: "Create", style: .default) { [weak alert, unowned self] _ in
            guard let alert = alert, let textFieldName = alert.textFields?.first else { return }
            let title = textFieldName.text!
            let store = Store(title: title)
            stores.append(store)
            self.tableView?.reloadData()
        }
        let dismissAlert = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(dismissAlert)
        alert.addAction(createStore)
        self.present(alert, animated: true, completion: nil)
    }
}
