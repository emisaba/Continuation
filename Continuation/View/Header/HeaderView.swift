import UIKit
import SDWebImage

protocol HeaderViewDelegate {
    func startAnimation(headerView: HeaderView)
}

class HeaderView: UIView {
    
    // MARK: - Properties
    
    public var delegate: HeaderViewDelegate?
    
    public var viewsInContainer = [HeaderViewCard]()
    public var topView: HeaderViewCard?
    
    public let baseView = UIView()
    
    public lazy var startButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "start-white"), for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2.5
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 13.5, bottom: 12, right: 12)
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        return button
    }()
    
    public var startAnimationCount = 0
    
    public var days: [Record] = [] {
        didSet {
            days.reverse()
            configureSlides()
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(baseView)
        baseView.fillSuperview()
        
        configureStartButtton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func didTapStartButton() {
        delegate?.startAnimation(headerView: self)
    }
    
    // MARK: - Helpers
    
    func configureSlides() {
        
        days.forEach { day in
            let headerView = HeaderViewCard(frame: .zero, day: day, animationView: false)
            baseView.addSubview(headerView)
            headerView.fillSuperview()
            headerView.alpha = 0
        }
        
        viewsInContainer = baseView.subviews.map { $0 as! HeaderViewCard }
        topView = viewsInContainer.last
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.viewsInContainer.forEach { $0.alpha = 1 }
        }
    }
    
    func configureStartButtton() {
        addSubview(startButton)
        startButton.setDimensions(height: 40, width: 40)
        startButton.anchor(top: topAnchor,
                           left: leftAnchor,
                           paddingTop: 20,
                           paddingLeft: 20)
    }
    
    func prepareToFetch() {
        baseView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func startButtonForAnimationVC() {
        startButton.layer.cornerRadius = 15
        startButton.layer.borderWidth = 2.5
        startButton.contentEdgeInsets = UIEdgeInsets(top: 13, left: 17, bottom: 13, right: 13)
        startButton.layer.borderColor = UIColor.white.cgColor
    }
}
