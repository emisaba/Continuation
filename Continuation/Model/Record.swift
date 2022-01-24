import UIKit
import Firebase

struct Record {
    let imageUrl: String
    let date: String
    let timeStamp: Timestamp
    
    init(day: [String: Any]) {
        self.imageUrl = day["imageUrl"] as? String ?? ""
        self.date = day["date"] as? String ?? ""
        self.timeStamp = day["timeStamp"] as? Timestamp ?? Timestamp()
    }
}
