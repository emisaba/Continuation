import UIKit

class RecordBaseView: RecordView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.backgroundColor = .white
        collectionView.register(RecordViewBaseCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDataSource

extension RecordBaseView {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! RecordViewBaseCell
        cell.countLabelNumber = indexPath.row + 1
        return cell
    }
}
