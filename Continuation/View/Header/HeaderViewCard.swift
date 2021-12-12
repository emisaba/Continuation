import UIKit
import SDWebImage

class HeaderViewCard: UIView {
    
    // MARK: - Properties
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    public let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .customRed()
        return label
    }()
    
    private var record: Record
    
    // MARK: - LifeCycle
    
    init(frame: CGRect, day: Record, animationView: Bool) {
        self.record = day
        dateLabel.font = .aileron(size: animationView ? 30 : 20)
        
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor,
                         left: leftAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor)
        imageView.sd_setImage(with: URL(string: record.imageUrl))
        print(" record.imageUrl:\( record.imageUrl)")
        
        imageView.addSubview(dateLabel)
        dateLabel.anchor(left: leftAnchor,
                         bottom: safeAreaLayoutGuide.bottomAnchor,
                         right: rightAnchor,
                         paddingRight: 10,
                         height: 50)
        dateLabel.text = record.date
    }
}
