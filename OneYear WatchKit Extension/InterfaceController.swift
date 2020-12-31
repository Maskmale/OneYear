//
//  InterfaceController.swift
//  OneYear WatchKit Extension
//
//  Created by Lojii on 2018/11/13.
//  Copyright © 2018 Lojii. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var progressLabel: WKInterfaceLabel!
    @IBOutlet weak var groupView: WKInterfaceGroup!
    
    var timer:Timer!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        titleLabel.setText(NSLocalizedString("Remaining 0", comment: "") + "\(OneYear.share.year)" + NSLocalizedString("Remaining 1", comment: ""))
    }
    
    override func willActivate() {
        timer = Timer.scheduledTimer(timeInterval: 0.09, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        super.willActivate()
    }
    
    @IBAction func groupDidClick(_ sender: Any) {
        switchType()
    }
    override func didDeactivate() {
        timer.invalidate()
        timer = nil
        super.didDeactivate()
    }

    @objc private func updateTime() {
        let progress = OneYear.share.currentProgress()
        if progress.count > 10 {
            progressLabel.setAttributedText(NSAttributedString(string: progress, attributes: [NSAttributedString.Key.font : UIFont(name: "Helvetica Neue", size: 24) ?? UIFont.systemFont(ofSize: 25)]))
        }else{
            progressLabel.setAttributedText(NSAttributedString(string: progress, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 40)]))
        }
        
    }
    
    @objc private func switchType() {
        OneYear.share.switchType()
    }
    
}
