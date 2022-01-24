import UIKit

class RecordView: UIView {
    
    // MARK: - Properties
    
    public var cellIdentifier = "cellIdentifier"
    
    public lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.font = .aileron(size: 30)
        label.text = CalendarHelper().titleMonthString(date: selectDate)
        label.textColor = .customRed()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var preMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "left"), for: .normal)
        button.addTarget(self, action: #selector(didTapPreMonthButton), for: .touchUpInside)
        button.layer.cornerRadius = 25
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return button
    }()
    
    private lazy var nextMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "right"), for: .normal)
        button.addTarget(self, action: #selector(didTapNextMonthButton), for: .touchUpInside)
        button.layer.cornerRadius = 25
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return button
    }()
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(RecordViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        cv.backgroundColor = .clear
        cv.backgroundColor = .customYellow()
        return cv
    }()

    public var selectDate = Date()
    public var totalSquare = [String]()
    public var fullDateForCheckIfRecordExist: [String] = []
    
    public var days: [Record] = [] {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setMonthView()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    func configureUI() {
        
        backgroundColor = .customYellow()
        
        addSubview(monthLabel)
        monthLabel.anchor(top: topAnchor,
                          left: leftAnchor,
                          right: rightAnchor,
                          paddingTop: 10,
                          height: 50)
        
        addSubview(preMonthButton)
        preMonthButton.anchor(left: leftAnchor,
                              paddingLeft: 10)
        preMonthButton.setDimensions(height: 50, width: 50)
        preMonthButton.centerY(inView: monthLabel)
        
        addSubview(nextMonthButton)
        nextMonthButton.anchor(right: rightAnchor,
                               paddingRight: 10)
        nextMonthButton.setDimensions(height: 50, width: 50)
        nextMonthButton.centerY(inView: monthLabel)
        
        let stackView = UIStackView(arrangedSubviews: [createWeekLabel(text: "Sun"),
                                                       createWeekLabel(text: "Mon"),
                                                       createWeekLabel(text: "Tue"),
                                                       createWeekLabel(text: "Wed"),
                                                       createWeekLabel(text: "Thu"),
                                                       createWeekLabel(text: "Fri"),
                                                       createWeekLabel(text: "Sat")])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: monthLabel.bottomAnchor,
                         left: leftAnchor,
                         right: rightAnchor,
                         height: 50)
        
        addSubview(collectionView)
        collectionView.anchor(top: stackView.bottomAnchor,
                              left: leftAnchor,
                              bottom: bottomAnchor,
                              right: rightAnchor,
                              paddingTop: 0,
                              paddingLeft: 10,
                              paddingRight: 10)
    }
    
    func createWeekLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = .customRed()
        label.font = .aileron(size: 16)
        return label
    }
}

// MARK: - UICollectionViewDataSource

extension RecordView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalSquare.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! RecordViewCell
        
        let dataForSquare = checkIfRecordExist(totalSquare: totalSquare[indexPath.row])
        cell.viewModel = RecordViewModel(dataForSquare: dataForSquare)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RecordView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 20) / 8
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
