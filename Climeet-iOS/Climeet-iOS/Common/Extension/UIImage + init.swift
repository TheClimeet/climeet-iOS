//
//  UIImage + .swift
//  Climeet-iOS
//
//  Created by mac on 11/29/24.
//

import Foundation
import UIKit.UIImage

extension UIImage {
    convenience init?(fromView view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        view.layer.render(in: context)
        
        guard let renderedImage = UIGraphicsGetImageFromCurrentImageContext(),
              let cgImage = renderedImage.cgImage else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        UIGraphicsEndImageContext()
        self.init(cgImage: cgImage)
    }
}
