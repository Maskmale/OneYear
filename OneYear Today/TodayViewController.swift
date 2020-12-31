//
//  TodayViewController.swift
//  Today
//
//  Created by Lojii on 2018/11/16.
//  Copyright © 2018 Lojii. All rights reserved.
//

import UIKit
import NotificationCenter

let WIDGETSIZEWIDTH = "WIDGETSIZEWIDTH"
let WIDGETSIZEHEIGHT = "WIDGETSIZEHEIGHT"

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var centerView:UIView!
    var progressLabel:UILabel!
    var titleLabel:UILabel!
    
    var timer:Timer!
    
    var widgetSize:CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ud = UserDefaults()
        
        let wSizew = ud.float(forKey: WIDGETSIZEWIDTH)
        let wSizeh = ud.float(forKey: WIDGETSIZEHEIGHT)
        
        if(wSizew < 50.0 || wSizeh < 50.0){
            return
        }
        widgetSize = CGSize(width: CGFloat(wSizew), height: CGFloat(wSizeh))
        initUI()
    }
    
    func initUI() -> Void {
        
        timer = Timer.scheduledTimer(timeInterval: 0.09, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
//        view.backgroundColor = .black
        
        centerView = UIView(frame: CGRect(x: 20, y:10, width: widgetSize.width-40, height: widgetSize.height-20))
        centerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(switchType)))
        centerView.layer.cornerRadius = 10
        centerView.clipsToBounds = true
        view.addSubview(centerView)
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width:  centerView.frame.width, height: centerView.frame.height / 2))
        titleLabel.text = NSLocalizedString("Remaining 0", comment: "") + "\(OneYear.share.year)" + NSLocalizedString("Remaining 1", comment: "")
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 28)
        titleLabel.textColor = UIColor.black
        centerView.addSubview(titleLabel)
        
        progressLabel = UILabel(frame: CGRect(x: 0, y: centerView.frame.height / 2, width:  centerView.frame.width, height: centerView.frame.height / 2))
        progressLabel.textAlignment = .center
        progressLabel.textColor = UIColor.black
        progressLabel.numberOfLines = 1
        progressLabel.font = UIFont.init(name: "Helvetica Neue", size: 28)
        centerView.addSubview(progressLabel)
        
    }
    
    @objc private func updateTime() {
        progressLabel.text = OneYear.share.currentProgress()
    }
    
    @objc private func switchType() {
        OneYear.share.switchType()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let ud = UserDefaults()
        let wSizew = ud.float(forKey: WIDGETSIZEWIDTH)
        let wSizeh = ud.float(forKey: WIDGETSIZEHEIGHT)
        if wSizeh < Float(50.0) || wSizew < Float(50.0) {
            ud.set(Float(maxSize.width), forKey: WIDGETSIZEWIDTH)
            ud.set(Float(maxSize.height), forKey: WIDGETSIZEHEIGHT)
            widgetSize = maxSize
            initUI()
        }
        
    }
    
}

