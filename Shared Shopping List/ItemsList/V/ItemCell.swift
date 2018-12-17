import UIKit

class ItemCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureCell(title: String) {
        titleLabel.text = title
    }
}
