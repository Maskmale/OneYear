//
//  ScreenShot.swift
//  OneYear
//
//  Created by Lojii on 2018/11/15.
//  Copyright © 2018 Lojii. All rights reserved.
//

import UIKit

extension UIView {
    
    /**
     Get the view's screen shot, this function may be called from any thread of your app.
     - returns: The screen shot's image.
    */
    func screenShot(_ scan:CGFloat = 0) -> UIImage? {
        
        guard frame.size.height > 0 && frame.size.width > 0 else {
            return nil
        }
        // 让所有图层显示出来先
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        showAllLayer(layer)
        CATransaction.commit()
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scan)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
    }
    
    func showAllLayer(_ l: CALayer) -> Void {
        l.sublayers?.forEach {
            $0.opacity = 1
            showAllLayer($0)
        }
    }
}
