//
//  ToastPopup.swift
//
//
//  Created by 임명협 on 08/02/2019.
//  Copyright © 2019 blucean. All rights reserved.
//

import Foundation
import UIKit
class ToastPopup {
    
    private static let sharedInstance = ToastPopup()
    private var toastView: UIView?
    
    var timer:Timer? = nil
    
    func startTimer() {
        if let _timer = self.timer {
            _timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(
            timeInterval: TimeInterval(2),
            target:self,
            selector:#selector(close),
            userInfo:nil,
            repeats:false)
    }
    
    @objc func onNextFlowTimer(_ timer:Timer) {
        self.close()
    }
    
    class func show(msg:String) {
        let toastView = ToastPopupView()
        toastView.backgroundColor = UIColor.clear
        toastView.alpha = 0
        
        if let window = UIApplication.shared.keyWindow {
            
            window.addSubview(toastView)
            
            UIView.animate(withDuration: 0.3, animations: {
                toastView.alpha = 1
            })
            
            toastView.labelText = msg

            
            let size = toastView.titleLabel.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 50 - 40, height:CGFloat.greatestFiniteMagnitude))
            
            toastView.frame = CGRect.init(origin: CGPoint(x: 25, y: UIScreen.main.bounds.height - 50 - 40 - size.height),
                                          size: CGSize(width: UIScreen.main.bounds.width - 50, height: size.height + 40))
            toastView.layer.cornerRadius = toastView.frame.height/2
            toastView.clipsToBounds = true
            
            sharedInstance.toastView?.removeFromSuperview()
            sharedInstance.toastView = toastView
            sharedInstance.startTimer()
        }
    }
    
    
    @objc func close() {
        if let toastView = ToastPopup.sharedInstance.toastView {
            UIView.animate(withDuration: 0.3, animations: {
                toastView.alpha = 0
            }, completion: { result in
                toastView.removeFromSuperview()
            })
        }
    }
}
