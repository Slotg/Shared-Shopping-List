import UIKit

class StoreCell: UITableViewCell {

    // MARK: - Properties
    static let reuseIdentifier = "StoreCell"
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    func configureCell(title: String, address: String?) {
        titleLabel.text = title
        addressLabel.text = address
    }
}
