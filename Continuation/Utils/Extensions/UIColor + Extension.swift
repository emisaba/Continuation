import UIKit

extension UIColor {
    
    static func createCustomColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func customYellow() -> UIColor {
        return createCustomColor(red: 233, green: 187, blue: 65)
    }
    
    static func customRed() -> UIColor {
        return createCustomColor(red: 166, green: 34, blue: 22)
    }
}
