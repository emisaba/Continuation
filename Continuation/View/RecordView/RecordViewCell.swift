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
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        iv.backgroundColor = .systemOrange
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
        imageView.fillSuperview()
        imageView.sd_setImage(with: viewModel.imageURL, completed: nil)
    }
}
