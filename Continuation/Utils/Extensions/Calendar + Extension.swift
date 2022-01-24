import UIKit

extension Calendar {
    
    static func isOver3days(day: Date) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let today = Date()
        let lastUpdateDay = day
        let days = calendar.dateComponents([.day], from: lastUpdateDay, to: today)
        let isOver3days = days.day ?? 0 > 3
        return isOver3days
    }
}
