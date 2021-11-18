import UIKit
import SDWebImage

protocol HeaderViewDelegate {
    func startAnimation(headerView: HeaderView)
    func endRecording(headerView: HeaderView)
}

class HeaderView: UIView {
    
    // MARK: - Properties
    
    public var delegate: HeaderViewDelegate?
    
    public var viewsInContainer = [HeaderViewCard]()
    public var topView: HeaderViewCard?
    
    public let baseView = UIView()
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "start"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        return button
    }()
    
    public var startAnimationCount = 0
    
    public let customAlert: CustomAlert = {
        let alert = CustomAlert()
        alert.alpha = 0
        return alert
    }()
    
    public var days: [Record] = [] {
        didSet {
            days.reverse()
            configureSlides()
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .customYellow()
        
        addSubview(baseView)
        baseView.fillSuperview()
        
        addSubview(customAlert)
        customAlert.centerX(inView: self)
        customAlert.centerY(inView: self)
        customAlert.setDimensions(height: 140, width: 220)
        
        configureStartButtton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func didTapStartButton() {
        
        startButton.removeFromSuperview()
        self.delegate?.startAnimation(headerView: self)
    }
    
    // MARK: - Helpers
    
    func configureSlides() {
        
        days.forEach { day in
            let headerView = HeaderViewCard(frame: .zero, day: day)
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
    
    func isLastSlide() -> Bool {
        return topView == nil ? true : false
    }
    
    func startAnimation() {
        
        Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { _ in
            UIView.animate(withDuration: 2) {
                self.topView?.alpha = 0
                
            } completion: { _ in
                self.topView?.removeFromSuperview()
                self.viewsInContainer.removeAll(where: { self.topView == $0 })
                self.topView = self.viewsInContainer.last
                
                if self.isLastSlide() {
                    self.delegate?.endRecording(headerView: self)
                    
                } else {
                    self.startAnimation()
                }
            }
        }
    }
    
    func prepareToFetch() {
        baseView.subviews.forEach { $0.removeFromSuperview() }
    }
}
