//
//  StoreCell.swift
//  Shared Shopping List
//
//  Created by Admin on 11/30/18.
//  Copyright © 2018 Guest account. All rights reserved.
//

import UIKit

class StoreCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureCell(title: String) {
        titleLabel.text = title
    }
}
