import UIKit

class HeaderViewCard: UIView {
    
    // MARK: - Properties
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .systemBlue
        return iv
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    private var record: Record
    
    // MARK: - LifeCycle
    
    init(frame: CGRect, day: Record) {
        self.record = day
        
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        addSubview(imageView)
        imageView.anchor(top: safeAreaLayoutGuide.topAnchor,
                             left: leftAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor)
        imageView.sd_setImage(with: URL(string: record.imageUrl))

        imageView.addSubview(dateLabel)
        dateLabel.anchor(top: safeAreaLayoutGuide.topAnchor,
                         left: leftAnchor,
                         right: rightAnchor,
                         paddingRight: 10,
                         height: 50)
        dateLabel.text = record.date
    }
}
