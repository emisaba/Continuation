import UIKit
import SDWebImage

class RecordViewBaseCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var countLabelNumber: Int = 0 {
        didSet { countLabel.text = "\(countLabelNumber)" }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        iv.backgroundColor = .systemOrange
        return iv
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        imageView.addSubview(countLabel)
        countLabel.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
