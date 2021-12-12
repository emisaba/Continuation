import UIKit
import SDWebImage
import ReplayKit
import Hero

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private let animation = UIImageView()
    
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
    
    public let characterImageView: UIImageView = {
        let iv = UIImageView()
        iv.animationImages = [#imageLiteral(resourceName: "start"), #imageLiteral(resourceName: "camera-white"), #imageLiteral(resourceName: "close"), #imageLiteral(resourceName: "camera"), #imageLiteral(resourceName: "camera2")]
        iv.animationRepeatCount = 0
        iv.animationDuration = 5
        iv.startAnimating()
        return iv
    }()
    
    private var characterDirectionToRight = false
    
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
        
        characterAnimation()
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
        
        view.backgroundColor = .customYellow()
        
        let vacantHeaderView = UIView()
        view.addSubview(vacantHeaderView)
        vacantHeaderView.anchor(top: view.topAnchor,
                                left: view.leftAnchor,
                                right: view.rightAnchor,
                                height: view.frame.height / 3)
        
        view.addSubview(cameraButton)
        cameraButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            paddingBottom: 10)
        cameraButton.setDimensions(height: 60, width: 60)
        cameraButton.centerX(inView: view)
        
        view.addSubview(headerView)
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 3)
        
        view.addSubview(recordView)
        recordView.anchor(top: vacantHeaderView.bottomAnchor,
                          left: view.leftAnchor,
                          bottom: cameraButton.topAnchor,
                          right: view.rightAnchor)
        
        view.addSubview(characterImageView)
        characterImageView.frame = CGRect(x: 0, y: view.frame.height - 50, width: 50, height: 50)
    }
    
    func characterAnimation() {
        
        UIView.animate(withDuration: 30) {
            self.characterImageView.frame.origin.x = self.characterDirectionToRight ? 0 : self.view.frame.width - 50
            
        } completion: {_ in
            self.characterAnimation()
            self.characterDirectionToRight.toggle()
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
    
    func startAnimation(headerView: HeaderView) {
        characterImageView.isHidden = true
        
        headerView.hero.id = "showAnimationView"
        
        let vc = AnimationViewController(records: records)
        vc.animationView.hero.id = "showAnimationView"
        vc.modalPresentationStyle = .fullScreen
        vc.isHeroEnabled = true
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.present(vc, animated: true, completion: nil)
        }
    }
}
