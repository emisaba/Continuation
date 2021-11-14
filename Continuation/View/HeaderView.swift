import UIKit
import SDWebImage

class HeaderView: UIView {
    
    // MARK: - Properties
    
    let container = UIView()
    private var viewsInContainer = [HeaderViewCard]()
    private var topView: HeaderViewCard?
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        return button
    }()
    
    var days: [Day] = [] {
        didSet { configureSlides() }
    }
    
    // MARK: - Lifecycle
    
    init(frame: CGRect, day: Day) {
        super.init(frame: frame)
        
        addSubview(container)
        container.fillSuperview()
        
        configureStartButtton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func didTapStartButton() {
        startButton.removeFromSuperview()
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            
            if self.topView == nil {
                self.configureSlides()
                self.configureStartButtton()
                timer.invalidate()
                
            } else {
                UIView.animate(withDuration: 1) {
                    self.topView?.alpha = 0
                    
                } completion: { done in
                    if done {
                        self.topView?.removeFromSuperview()
                        self.viewsInContainer.removeAll(where: { self.topView == $0 })
                        self.topView = self.viewsInContainer.last
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    func configureSlides() {
        
        days.forEach{ day in
            let headerView = HeaderViewCard(frame: .zero, day: day)
            container.addSubview(headerView)
            headerView.fillSuperview()
        }
        
        viewsInContainer = container.subviews.map { $0 as! HeaderViewCard }
        topView = viewsInContainer.last
    }
    
    func configureStartButtton() {
        addSubview(startButton)
        startButton.setDimensions(height: 60, width: 60)
        startButton.centerX(inView: container)
        startButton.centerY(inView: container)
    }
}
