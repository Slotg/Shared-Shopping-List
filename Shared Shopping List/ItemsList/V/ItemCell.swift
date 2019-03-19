import UIKit

class ItemCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "ItemCell"
    var isDone = false
    var title: String? = nil {
        didSet {
            switch isDone {
            case true:
                if let text = title {
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
                    titleLabel.attributedText = attributeString
                    contentView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5155714897)
                    titleLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                }
            case false:
                titleLabel.text = title
                contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                titleLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureCell(title: String, isDone: Bool = false) {
        titleLabel.text = title
        self.isDone = isDone
        self.title = title
    }
}
