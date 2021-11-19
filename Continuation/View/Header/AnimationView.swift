import UIKit

protocol AnimationViewDelegate {
    func startAnimation(animationView: AnimationView)
    func endRecording(animationView: AnimationView)
}

class AnimationView: HeaderView {
    
    // MARK: - Properties
    
    public var animationViewDelegate: AnimationViewDelegate?
    
    public let customAlert: CustomAlert = {
        let alert = CustomAlert()
        alert.alpha = 0
        return alert
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    
    @objc override func didTapStartButton() {
        startButton.alpha = 9
        animationViewDelegate?.startAnimation(animationView: self)
    }
    
    // MARK: - Helpers
    
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
                    self.animationViewDelegate?.endRecording(animationView: self)
                    
                } else {
                    self.startAnimation()
                }
            }
        }
    }
    
    override func configureStartButtton() {
        addSubview(startButton)
        startButton.setDimensions(height: 90, width: 90)
        startButton.centerX(inView: baseView)
        startButton.centerY(inView: baseView)
    }
    
    override func configureSlides() {
        
        days.forEach { day in
            let headerView = HeaderViewCard(frame: .zero, day: day, animationView: true)
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
}
