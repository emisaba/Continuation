import UIKit
import ReplayKit

// MARK: - HeaderViewDelegate

extension MainViewController: HeaderViewDelegate {
    func startAnimation(headerView: HeaderView) {
        
        animationView.isHidden = false
        coloseAnimationButton.alpha = 0
        
        UIView.animate(withDuration: 0.1) {
            self.animationView.frame = self.view.frame
            self.view.layoutIfNeeded()

        } completion: { _ in
            self.recorder.startRecording { error in
                if let error = error {
                    print("failed to start recording: \(error.localizedDescription)")
                }
                self.animationView.startAnimation()
            }
        }
    }
}

// MARK: - AnimationViewDelegate

extension MainViewController: AnimationViewDelegate {
    
    func endRecording(animationView: AnimationView) {
        
        recorder.stopRecording { previewVC, error in
            if let error = error {
                print("failed to stop recording: \(error.localizedDescription)")
            }
            
            self.animationView.customAlert.alpha = 1
            self.animationView.customAlert.delegate = self
            self.coloseAnimationButton.alpha = 1
            
            if let previewVC = previewVC {
                self.previewVC = previewVC
            }
        }
    }
    
    func startAnimation(animationView: AnimationView) {
        
        animationView.isHidden = false
        coloseAnimationButton.alpha = 0
        
        UIView.animate(withDuration: 0.1) {
            self.animationView.frame.size.height = self.view.frame.height
            self.view.layoutIfNeeded()

        } completion: { _ in
            self.recorder.startRecording { error in
                if let error = error {
                    print("failed to start recording: \(error.localizedDescription)")
                }
                animationView.startAnimation()
            }
        }
    }
}

// MARK: - RPPreviewViewControllerDelegate

extension MainViewController: RPPreviewViewControllerDelegate {
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        showAnimationView()
    }
}

// MARK: - CustomAlertDelegate

extension MainViewController: CustomAlertDelegate {
    
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
