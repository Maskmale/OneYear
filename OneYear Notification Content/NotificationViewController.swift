//
//  NotificationViewController.swift
//  OneYear Notification Content
//
//  Created by Lojii on 2018/11/19.
//  Copyright © 2018 Lojii. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    var centerView:UIView!
    var progressLabel:UILabel!
    var titleLabel:UILabel!
    
    var timer:Timer!
    
//    var widgetSize:CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
//        self.label?.text = notification.request.content.body
        initUI()
    }
    
    func initUI() -> Void {
        
        timer = Timer.scheduledTimer(timeInterval: 0.09, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        view.backgroundColor = .black
        
        centerView = UIView(frame: view.bounds)
        centerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(switchType)))
        centerView.layer.cornerRadius = 10
        centerView.clipsToBounds = true
        view.addSubview(centerView)
        
        titleLabel = UILabel(frame: CGRect(x: 20, y: 50, width:  centerView.frame.width - 40, height: centerView.frame.height / 2))
        titleLabel.text = NSLocalizedString("Remaining 0", comment: "") + "\(OneYear.share.year)" + NSLocalizedString("Remaining 1", comment: "")
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 200)
        titleLabel.textColor = UIColor.white
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.baselineAdjustment = .alignCenters
        centerView.addSubview(titleLabel)
        
        progressLabel = UILabel(frame: CGRect(x: 20, y: centerView.frame.height / 2 - 50, width:  centerView.frame.width-40, height: centerView.frame.height / 2))
        progressLabel.textAlignment = .center
        progressLabel.textColor = UIColor.white
        progressLabel.numberOfLines = 1
        progressLabel.font = UIFont.init(name: "Helvetica Neue", size: 100)
        progressLabel.adjustsFontSizeToFitWidth = true
        progressLabel.baselineAdjustment = .alignCenters
        centerView.addSubview(progressLabel)
        
    }
    
    @objc private func updateTime() {
        progressLabel.text = OneYear.share.currentProgress()
    }
    
    @objc private func switchType() {
        OneYear.share.switchType()
    }

}
