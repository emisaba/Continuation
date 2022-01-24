import UIKit

struct RecordViewModel {
    let dataForSquare: DataForSquare
    
    var imageURL: URL? {
        return URL(string: dataForSquare.record?.imageUrl ?? "")
    }
    
    var dateString: String {
        return dataForSquare.dateString
    }
    
    var dateTextColor: UIColor {
        return dataForSquare.record != nil ? .white : .customRed()
    }
    
    var shouldShowSquare: Bool {
        return dataForSquare.dateString == ""
    }
    
    init(dataForSquare: DataForSquare) {
        self.dataForSquare = dataForSquare
    }
}
