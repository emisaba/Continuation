import UIKit
import ReplayKit

class AnimationViewController: UIViewController {
    
    // MARK: - Properties
    
    public lazy var animationView: AnimationView = {
        let view = AnimationView()
        view.animationViewDelegate = self
        view.startButton.isHidden = true
        return view
    }()
    
    public lazy var closeAnimationButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.alpha = 0
        button.addTarget(self, action: #selector(didTapCloseAnimationButton), for: .touchUpInside)
        return button
    }()
    
    public let recorder = RPScreenRecorder.shared()
    public var previewVC: RPPreviewViewController?
    
    private let recordView = RecordView()
    
    private var isFirstTime = true
    
    // MARK: - LifeCycle
    
    init(records: [Record]) {
        super.init(nibName: nil, bundle: nil)
        self.animationView.days = records
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    
    @objc func didTapCloseAnimationButton() {
        
        isFirstTime = false
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(animationView)
        animationView.fillSuperview()
        
        view.addSubview(closeAnimationButton)
        closeAnimationButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                     right: view.rightAnchor,
                                     paddingTop: 10,
                                     paddingRight: 10)
        closeAnimationButton.setDimensions(height: 60, width: 60)
    }
    
    func showAnimationView() {
        animationView.customAlert.alpha = 0
        
        animationView.startAnimationCount = 0
        animationView.configureSlides()
        animationView.startButton.isHidden = false
        
        UIView.animate(withDuration: 0.25) {
            self.animationView.viewsInContainer.forEach { $0.alpha = 1 }
        }
    }
}

// MARK: - AnimationViewDelegate

extension AnimationViewController: AnimationViewDelegate {
    
    func didPrepareSlides() {
        configureUI()
        
        if isFirstTime {
            startAnimation()
            isFirstTime = false
        }
    }
    
    func startAnimation() {
        
        closeAnimationButton.alpha = 0
        
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
            self.recorder.startRecording { error in
                if let error = error {
                    print("failed to start recording: \(error.localizedDescription)")
                }
                self.animationView.startAnimation()
            }
        }
    }
    
    func endRecording(animationView: AnimationView) {
        
        recorder.stopRecording { previewVC, error in
            if let error = error {
                print("failed to stop recording: \(error.localizedDescription)")
            }
            
            self.animationView.customAlert.alpha = 1
            self.animationView.customAlert.delegate = self
            self.closeAnimationButton.alpha = 1
            
            if let previewVC = previewVC {
                self.previewVC = previewVC
            }
        }
    }
}

// MARK: - RPPreviewViewControllerDelegate

extension AnimationViewController: RPPreviewViewControllerDelegate {
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        showAnimationView()
    }
}

// MARK: - CustomAlertDelegate

extension AnimationViewController: CustomAlertDelegate {
    
    func onClickYesButton() {
        guard let previewVC = self.previewVC else { return }
        previewVC.previewControllerDelegate = self
        previewVC.modalPresentationStyle = .fullScreen

        self.present(previewVC, animated: true) {
            let safeArea = self.view.safeAreaInsets
            let safeAreaHeight = self.view.frame.height - (safeArea.top + safeArea.bottom)
            let scale = safeAreaHeight / self.view.frame.height
            previewVC.view.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    func onClickNoButton() {
        showAnimationView()
    }
}
