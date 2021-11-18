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
        label.font = .aileron(size: 50)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    public lazy var yesButton = createButton(title: "yes", titleColor: .customRed())
    public lazy var noButton = createButton(title: "no", titleColor: .systemGray)
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let buttonStackView = UIStackView(arrangedSubviews: [noButton, yesButton])
        buttonStackView.distribution = .fillEqually
        buttonStackView.axis = .horizontal
        
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
    
    func createButton(title: String, titleColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = .aileron(size: 48)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(didClickButton), for: .touchUpInside)
        return button
    }
}
