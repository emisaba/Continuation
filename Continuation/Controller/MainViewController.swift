import UIKit
import SDWebImage
import ReplayKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    let animation = UIImageView()
    
    private lazy var headerView: HeaderView = {
        let view = HeaderView()
        view.delegate = self
        return view
    }()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customRed()
        button.layer.cornerRadius = 30
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.setImage(#imageLiteral(resourceName: "camera-white"), for: .normal)
        button.addTarget(self, action: #selector(didTapCameraButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var coloseAnimationButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.alpha = 0
        button.addTarget(self, action: #selector(didTapCloseAnimationButton), for: .touchUpInside)
        return button
    }()
    
    private let recorder = RPScreenRecorder.shared()
    private var previewVC: RPPreviewViewController?
    
    private let recordBaseView = RecordBaseView()
    private let recordView = RecordView()
    
    private var records: [Record] = [] {
        didSet {
            recordView.days = records
            headerView.days = records
        }
    }
    
    // MARK: - Lifecycel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRecord()
        configureUI()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - API
    
    func fetchRecord() {
        RecordService.fetchDayInfo { days in
            self.records = days
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapCameraButton() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func didTapCloseAnimationButton() {
        
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        view.backgroundColor = .customYellow()
        
        let vacantHeaderView = UIView()
        view.addSubview(vacantHeaderView)
        vacantHeaderView.anchor(top: view.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         height: view.frame.height / 3)
        
        view.addSubview(headerView)
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 3)
        
        headerView.addSubview(coloseAnimationButton)
        coloseAnimationButton.frame = CGRect(x: headerView.frame.width - 80,
                                                 y: 40,
                                                 width: 60, height: 60)
        
        view.addSubview(cameraButton)
        cameraButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            paddingBottom: 10)
        cameraButton.setDimensions(height: 60, width: 60)
        cameraButton.centerX(inView: view)

        view.addSubview(recordBaseView)
        recordBaseView.anchor(top: vacantHeaderView.bottomAnchor,
                              left: view.leftAnchor,
                              bottom: cameraButton.topAnchor,
                              right: view.rightAnchor)

        view.addSubview(recordView)
        recordView.anchor(top: vacantHeaderView.bottomAnchor,
                          left: view.leftAnchor,
                          bottom: cameraButton.topAnchor,
                          right: view.rightAnchor)
    }
    
    func showStartAnimationView() {
        headerView.customAlert.alpha = 0
        dismiss(animated: true, completion: nil)
        
        headerView.startAnimationCount = 0
        headerView.configureSlides()
        headerView.configureStartButtton()
        
        UIView.animate(withDuration: 0.25) {
            self.headerView.viewsInContainer.forEach { $0.alpha = 1 }
        }
    }
}

// MARK: - UIImagePickerController

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        let date = DateFormatter.today().string(from: Date())
        
        RecordService.uploadDaysInfo(info: RecordInfo(image: image, date: date)) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.headerView.prepareToFetch()
            self.fetchRecord()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - HeaderViewDelegate

extension MainViewController: HeaderViewDelegate {
    
    func endRecording(headerView: HeaderView) {
        
        recorder.stopRecording { previewVC, error in
            if let error = error {
                print("failed to stop recording: \(error.localizedDescription)")
            }
            
            self.headerView.customAlert.alpha = 1
            self.headerView.customAlert.delegate = self
            self.coloseAnimationButton.alpha = 1
            
            if let previewVC = previewVC {
                self.previewVC = previewVC
            }
        }
    }
    
    func startAnimation(headerView: HeaderView) {
        createAnimationView()
        coloseAnimationButton.alpha = 0
        
        UIView.animate(withDuration: 0.1) {
            self.headerView.frame = self.view.frame
            self.view.layoutIfNeeded()

        } completion: { _ in
            self.recorder.startRecording { error in
                if let error = error {
                    print("failed to start recording: \(error.localizedDescription)")
                }
                headerView.startAnimation()
            }
        }
    }
    
    func createAnimationView() {
        view.addSubview(self.headerView)
        headerView.frame = CGRect(x: 0,
                                       y: 0,
                                       width: self.view.frame.width,
                                       height: self.view.frame.height / 3)
        headerView.backgroundColor = .white
    }
}

// MARK: - RPPreviewViewControllerDelegate

extension MainViewController: RPPreviewViewControllerDelegate {
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        showStartAnimationView()
    }
}

// MARK: - CustomAlertDelegate

extension MainViewController: CustomAlertDelegate {
    
    func onClickYesButton() {
        guard let previewVC = self.previewVC else { return }
        previewVC.previewControllerDelegate = self
        previewVC.modalPresentationStyle = .fullScreen
        self.present(previewVC, animated: true, completion: nil)
    }
    
    func onClickNoButton() {
        showStartAnimationView()
    }
}
