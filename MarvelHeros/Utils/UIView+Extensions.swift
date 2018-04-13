import UIKit

extension UIView {
    
    @objc var safeLayoutFrame: CGRect {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.layoutFrame
        } else {
            return frame
        }
    }
}
