import UIKit

struct RecordViewModel {
    let day: Record
    
    var imageURL: URL? {
        return URL(string: day.imageUrl)
    }
    
    init(day: Record) {
        self.day = day
    }
}
