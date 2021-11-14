import UIKit

class RecordView: UIView {
    
    // MARK: - Properties
    
    private var cellIdentifier = "cellIdentifier"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = frame.width / 20
        layout.minimumInteritemSpacing = frame.width / 20
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(RecordViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        cv.backgroundColor = .white
        cv.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return cv
    }()
    
    var days: [Record] = [] {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDataSource

extension RecordView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! RecordViewCell
        cell.viewModel = RecordViewModel(day: days[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RecordView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.width / 10
        return CGSize(width: width, height: width)
    }
}
