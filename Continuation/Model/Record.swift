import UIKit

struct Record {
    let imageUrl: String
    let date: String
    
    init(day: [String: Any]) {
        self.imageUrl = day["imageUrl"] as? String ?? ""
        self.date = day["date"] as? String ?? ""
    }
}
