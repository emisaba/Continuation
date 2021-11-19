import UIKit
import SDWebImage

class RecordViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: RecordViewModel? {
        didSet { configureUI() }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.layer.borderWidth = 1.5
        iv.layer.borderColor = UIColor.customRed().cgColor
        iv.clipsToBounds = true
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        guard let viewModel = viewModel else { return }
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor,
                         left: leftAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor,
                         paddingBottom: 2,
                         paddingRight: 2)
        imageView.sd_setImage(with: viewModel.imageURL, completed: nil)
    }
}
