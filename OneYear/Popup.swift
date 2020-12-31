//
//  Popup.swift
//  OneYear
//
//  Created by Lojii on 2018/11/15.
//  Copyright © 2018 Lojii. All rights reserved.
//

import UIKit

public enum PopupAlign {
    case top
    case center
    case bottom
    case left
    case right
}

public enum PopupAnimation {
    case none
    case bounce
}

let bgTag = 4521684

extension UIViewController {
    public func showPop(popView:UIView!, from: PopupAlign = .top, to: PopupAlign = .top, animation: PopupAnimation = .bounce) {
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.tag = bgTag
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPop)))
        
        let effe = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        effe.frame = backgroundView.bounds
        backgroundView.addSubview(effe)
        
        view.addSubview(backgroundView)
        
        var fromFrame = popView.frame
        switch from {
        case .top:
            fromFrame.origin.y = -fromFrame.size.height
        case .bottom:
            fromFrame.origin.y = SCREENHEIGHT
        case .left:
            fromFrame.origin.x = -fromFrame.size.width
        case .right:
            fromFrame.origin.x = SCREENWIDTH
        default: break
        }
        
        var toFrame = popView.frame
        switch to {
        case .top:
            toFrame.origin.y = STATUSBARHEIGHT + 30
        case .bottom:
            toFrame.origin.y = SCREENHEIGHT - toFrame.size.height
        case .left:
            toFrame.origin.x = 0
        case .right:
            toFrame.origin.x = SCREENWIDTH
        default: break
        }
        
        popView.frame = fromFrame
        backgroundView.addSubview(popView)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: .curveEaseIn, animations: {
            popView.frame = toFrame
        }, completion: nil)
        
    }
    
    @objc public func dismissPop(){
        let backgroundView = view.viewWithTag(bgTag)
        backgroundView?.removeFromSuperview()
        
        
        
    }
}
