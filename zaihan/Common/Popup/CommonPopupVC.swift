//
//  CommonPopupVC.swift
//  localpay
//
//  Created by MyongHyupLim on 11/12/2018.
//  Copyright © 2022  All rights reserved.
//

import UIKit

enum CPButtonType {
    case one, two
}

struct CommonPopupData {
    var tradeAmt = ""
    var authDate = ""
    var authTime = ""
}

class CommonPopupVC: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    @IBInspectable var oneTitle: String = "" {
        didSet {oneButton.setTitle(self.oneTitle, for: .normal)}
    }
    @IBInspectable var cancelTitle: String = "" {
        didSet {cancelButton.setTitle(self.cancelTitle, for: .normal)}
    }
    @IBInspectable var okTitle: String = "" {
        didSet {okButton.setTitle(self.okTitle, for: .normal)}
    }
    
    var titleText: String = "" {
        didSet {titleLabel.text = titleText}
    }
    var detailText: String = "" {
        didSet {textLabel.text = self.detailText}
    }
    
    var oneBtnSelected: (() -> ())?
    var cancelBtnSelected: (() -> ())?
    var okBtnSelected: (() -> ())?
    
    static func instance() -> CommonPopupVC {
        return UIStoryboard(name: "CommonPopup", bundle: nil).instantiateViewController(withIdentifier: "CommonPopupVC") as! CommonPopupVC
    }
    
    /**
     기본세팅
     타입: 2버튼
     취소: 취소
     확인, 원: 확인
     */
    static func present( _ target: UIViewController, type: CPButtonType, configuration: ((CommonPopupVC) -> ())?) {
        let commonPopupVC = CommonPopupVC.instance()
        commonPopupVC.modalPresentationStyle = .overCurrentContext
        commonPopupVC.view.isHidden = false
        
        commonPopupVC.oneButton.isHidden = !(type == .one)
        commonPopupVC.cancelButton.isHidden = (type == .one)
        commonPopupVC.okButton.isHidden = (type == .one)
        
        commonPopupVC.cancelTitle = "취소"
        commonPopupVC.okTitle = "확인"
        commonPopupVC.oneTitle = "확인"
        
        configuration?(commonPopupVC)
        
        target.present(commonPopupVC, animated: false) {
            UIView.animate(withDuration: 0.3) {commonPopupVC.backView.alpha = 0.8}
        }
    }
    
    @IBAction private func one(_ button: UIButton) {
        dismiss(animated: false) {
            self.detailText = ""
            self.oneBtnSelected?()
        }
    }
    
    @IBAction private func cancel(_ button: UIButton) {
        dismiss(animated: false) {
            self.detailText = ""
            self.cancelBtnSelected?()
        }
    }
    
    @IBAction private func ok(_ button: UIButton) {
        dismiss(animated: false) {
            self.detailText = ""
            self.okBtnSelected?()
        }
    }
    
    deinit {
        print("CommonPopupVC Deinit!!!")
    }
}

