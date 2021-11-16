import UIKit
import SDWebImage

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private let headerView = HeaderView()
    private let recordBaseView = RecordBaseView()
    private let recordView = RecordView()
    
    private var records: [Record] = [] {
        didSet {
            recordView.days = records
            headerView.days = records
        }
    }
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapCameraButton), for: .touchUpInside)
        return button
    }()
    
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
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(headerView)
        headerView.backgroundColor = .systemBlue
        headerView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor,
                          height: view.frame.height / 3)
        
        view.addSubview(cameraButton)
        cameraButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            paddingBottom: 30)
        cameraButton.setDimensions(height: 60, width: 60)
        cameraButton.centerX(inView: view)
        
        view.addSubview(recordBaseView)
        recordBaseView.anchor(top: headerView.bottomAnchor,
                              left: view.leftAnchor,
                              bottom: cameraButton.topAnchor,
                              right: view.rightAnchor)
        
        view.addSubview(recordView)
        recordView.anchor(top: headerView.bottomAnchor,
                          left: view.leftAnchor,
                          bottom: cameraButton.topAnchor,
                          right: view.rightAnchor)
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
