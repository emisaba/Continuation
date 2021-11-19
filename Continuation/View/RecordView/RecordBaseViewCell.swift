import UIKit
import SDWebImage

class RecordViewBaseCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var countLabelNumber: Int = 0 {
        didSet { countLabel.text = "\(countLabelNumber)" }
    }
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.layer.borderWidth = 1.5
        iv.layer.borderColor = UIColor.customRed().cgColor
        iv.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        iv.layer.shadowOffset = CGSize(width: 2, height: 2)
        iv.layer.shadowRadius = 2
        iv.layer.shadowOpacity = 1
        iv.backgroundColor = .white
        return iv
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .customRed()
        label.font = .aileron(size: 20)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor,
                         left: leftAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor,
                         paddingBottom: 2,
                         paddingRight: 2)
        
        imageView.addSubview(countLabel)
        countLabel.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
