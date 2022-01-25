import UIKit

extension UIFont {
    static func aileron(size: CGFloat) -> UIFont {
        return UIFont(name: "Ailerons-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func senobi(size: CGFloat) -> UIFont {
        return UIFont(name: "Senobi-Gothic-Regular", size: size) ?? .systemFont(ofSize: size)
    }
}
