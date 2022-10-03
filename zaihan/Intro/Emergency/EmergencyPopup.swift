//
//  EmergencyPopup.swift
//  zaihan
//
//  Created by MYONHYUP LIM on 2022/09/03.
//

import Foundation
import UIKit

class EmergencyPopup : UIViewController {
    static func instance() -> EmergencyPopup {
        return UIStoryboard(name: "EmergencyPopup", bundle: nil)
            .instantiateViewController(withIdentifier: "EmergencyPopup") as! EmergencyPopup
    }
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    var content:Emergency.Response? = nil
    
    var complete: (() -> ())?
    
    override func viewDidLoad() {
        contentTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 20)
        titleLabel.text = content?.data?.title ?? ""
        descLabel.text = content?.data?.title ?? ""
        timeLabel.text = "\(content?.data?.shutdownStartAt ?? "") ~ \(content?.data?.shutdownEndAt ?? "")"
        contentTextView.text = content?.data?.description ?? ""
    }
    @IBAction func onConfirm(_ sender: Any) {
        dismiss(animated: false, completion: {[weak self] in
            guard let self = self else { return }
            self.complete?()
            self.complete = nil
        })
    }
}
