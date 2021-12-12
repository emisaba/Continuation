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
        button.setImage(#imageLiteral(resourceName: "start"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.layer.cornerRadius = 30
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
        self.delegate?.startAnimation(headerView: self)
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
        startButton.setDimensions(height: 60, width: 60)
        startButton.centerX(inView: baseView)
        startButton.centerY(inView: baseView)
    }
    
    func prepareToFetch() {
        baseView.subviews.forEach { $0.removeFromSuperview() }
    }
}
