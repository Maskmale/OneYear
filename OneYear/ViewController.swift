//
//  ViewController.swift
//  OneYear
//
//  Created by Lojii on 2018/11/13.
//  Copyright © 2018 Lojii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var centerView:UIView!
    var progressLabel:UILabel!
    var titleView:CharacterAnimationView!
    
    var shareBtn:UIButton!
    var settingBtn:UIButton!
    
    var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fadein(with: titleView.shaffle())
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    func initUI() -> Void {
        
        timer = Timer.scheduledTimer(timeInterval: 0.09, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        centerView = UIView(frame: CGRect(x: 0, y: (SCREENHEIGHT-SCREENWIDTH)/2, width: SCREENWIDTH, height: SCREENWIDTH))
        centerView.backgroundColor = .black
        centerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(switchType)))
        view.addSubview(centerView)
        
        progressLabel = UILabel(frame: CGRect(x: 40, y: SCREENWIDTH / 2, width: SCREENWIDTH-80, height: 80))
        progressLabel.textAlignment = .center
        
        progressLabel.textColor = UIColor.white
        progressLabel.font = UIFont.init(name: "Helvetica Neue", size: 100)
        progressLabel.adjustsFontSizeToFitWidth = true
        progressLabel.baselineAdjustment = .alignCenters
        centerView.addSubview(progressLabel)
        
        titleView = CharacterAnimationView()
        titleView.text = NSLocalizedString("Remaining 0", comment: "") + "\(OneYear.share.year)" + NSLocalizedString("Remaining 1", comment: "")
        titleView.font = UIFont(name: "Helvetica Neue", size: 42)!
        titleView.textColor = UIColor.white
        titleView.translatesAutoresizingMaskIntoConstraints = true
        titleView.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        titleView.frame.size.width = SCREENWIDTH
        titleView.center.x = centerView.center.x
        titleView.frame.origin.y = SCREENWIDTH/2 - 60
        centerView.addSubview(titleView)
        titleView.create()
        
        shareBtn = UIButton(frame: CGRect(x: SCREENWIDTH - 30 - 20, y: STATUSBARHEIGHT + 20, width: 30, height: 30))
        shareBtn.setImage(UIImage(named: "share3"), for: .normal)
        shareBtn.addTarget(self, action: #selector(share), for: .touchUpInside)
        view.addSubview(shareBtn)
        
        settingBtn = UIButton(frame: CGRect(x: SCREENWIDTH - 30 - 20 - 30 - 10, y: STATUSBARHEIGHT + 20, width: 30, height: 30))
        settingBtn.setImage(UIImage(named: "alarmoff"), for: .normal)
        settingBtn.setImage(UIImage(named: "alarmon"), for: .selected)
        settingBtn.addTarget(self, action: #selector(openNotification), for: .touchUpInside)
        NotificatioManager.share.isOpen("OneYear") { (open) in
            DispatchQueue.main.async {
                self.settingBtn.isSelected = open
            }
        }
        view.addSubview(settingBtn)
    }
    
    @objc private func openNotification() {
        if settingBtn.isSelected {
            // 清除
            NotificatioManager.share.removeAllNotifications()
            settingBtn.isSelected = false
        }else{
            // 添加
            NotificatioManager.share.openNotification { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        self.settingBtn.isSelected = true
                    }
                }else{
                    // 无权限
                    DispatchQueue.main.async {
                        self.showAlert()
                    }
                }
            }
        }
    }
    
    func showAlert() -> Void {
        // 创建
        let alertController = UIAlertController(title: NSLocalizedString("Prompt", comment: ""), message: NSLocalizedString("No notification permission please go to Settings to open", comment: ""), preferredStyle:.alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (UIAlertAction) in
            if let url = URL(string: UIApplication.openSettingsURLString){
                if (UIApplication.shared.canOpenURL(url)){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func share() {
//        NotificatioManager.share.isOpen("OneYear") { (open) in
//            DispatchQueue.main.async {
//                self.settingBtn.isSelected = open
//            }
//        }

        let shotImg = centerView.screenShot()

        let popView = UIView(frame: CGRect(x: 40, y: 0, width: SCREENWIDTH - 80, height: SCREENWIDTH - 80))
        let imgView = UIImageView(frame: popView.bounds)
        imgView.image = shotImg
        popView.addSubview(imgView)

        // 添加
        let name = NSLocalizedString("CFBundleDisplayName", comment: "")
        let w = name == "流年" ? 50.0 : 65.0

        let watermark = UIView(frame: CGRect(x: Double(popView.frame.width - CGFloat(w)), y: Double(popView.frame.height - 20), width: w, height: 20.0))
        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        iconView.image = UIImage(named: "icon")
        
        let title = UILabel(frame: CGRect(x: 22, y: 0, width: w - 22, height: 20))
        title.text = name
        title.textColor = .white
        title.font = UIFont.systemFont(ofSize: 10, weight: .light)
        title.textAlignment = .left
        watermark.addSubview(iconView)
        watermark.addSubview(title)

        popView.addSubview(watermark)

        showPop(popView: popView)

        guard let shareImg = popView.screenShot() else {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.popShareActivity(shareImg)
        }
        
    }
    
    func popShareActivity(_ shareImg: UIImage) -> () {
        let activityController = UIActivityViewController(activityItems: [shareImg], applicationActivities: nil)
        activityController.completionWithItemsHandler = { (type, flag, array, error) in
            self.dismissPop()
        }
        let popover = activityController.popoverPresentationController
        if (popover != nil) {
            popover?.permittedArrowDirections = .any
            popover?.sourceView = self.view
            popover?.sourceRect = CGRect(x: 0, y:Int(UIScreen.main.bounds.size.height), width: Int(UIScreen.main.bounds.size.width), height: 30)
        }
        present(activityController, animated: true) { }
    }
    
    @objc private func updateTime() {
        progressLabel.text = OneYear.share.currentProgress()
    }
    
    @objc private func switchType() {
        OneYear.share.switchType()
    }
    
}

