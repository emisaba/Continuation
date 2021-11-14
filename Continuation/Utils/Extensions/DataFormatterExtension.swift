import UIKit

extension DateFormatter {
    static func today() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }
}
