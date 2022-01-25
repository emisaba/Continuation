import UIKit

protocol CustomAlertDelegate {
    func onClickYesButton()
    func onClickNoButton()
}

class CustomAlert: UIView {
    
    // MARK: - Properties
    
    public var delegate: CustomAlertDelegate?
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "save?"
        label.font = .aileron(size: 38)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    public lazy var yesButton = createButton(title: "yes", titleColor: .customRed(), isYes: true)
    public lazy var noButton = createButton(title: "no", titleColor: .white, isYes: false)
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        let buttonStackView = UIStackView(arrangedSubviews: [noButton, yesButton])
        buttonStackView.distribution = .fillEqually
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20
        
        let alertStackView = UIStackView(arrangedSubviews: [questionLabel, buttonStackView])
        alertStackView.distribution = .fillEqually
        alertStackView.axis = .vertical
        alertStackView.spacing = 30
        
        addSubview(alertStackView)
        alertStackView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func didClickButton(sender: UIButton) {
        
        switch sender {
        case yesButton:
            delegate?.onClickYesButton()
        case noButton:
            delegate?.onClickNoButton()
        default:
            break
        }
    }
    
    // MARK: - Helpers
    
    func createButton(title: String, titleColor: UIColor, isYes: Bool) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .aileron(size: 30)
        button.titleLabel?.textAlignment = .left
        button.addTarget(self, action: #selector(didClickButton), for: .touchUpInside)
        button.layer.cornerRadius = 10
        
        if isYes {
            button.backgroundColor = .customRed()
        } else {
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 2
        }
        return button
    }
}
