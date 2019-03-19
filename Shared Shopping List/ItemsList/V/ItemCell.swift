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
                    let view = UIView(frame: contentView.frame)
                    view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)
                    addSubview(view)
                }
            case false:
                titleLabel.text = title
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
