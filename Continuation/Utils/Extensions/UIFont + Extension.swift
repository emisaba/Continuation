import UIKit

extension UIFont {
    static func matchbook(size: CGFloat) -> UIFont {
        return UIFont(name: "Matchbook", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func cosmo(size: CGFloat) -> UIFont {
        return UIFont(name: "x3cosmo-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func aileron(size: CGFloat) -> UIFont {
        return UIFont(name: "Ailerons-Regular", size: size) ?? .systemFont(ofSize: size)
    }
}
