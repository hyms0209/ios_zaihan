//
//  ToastPopupView.swift
//  Zaihan
//
//  Created by 임명협 on 08/02/2019.
//  Copyright © 2022 All rights reserved.
//

import Foundation
import UIKit

class ToastPopupView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    var labelText:String = ""{
        didSet{
            titleLabel.text = labelText
            titleLabel.sizeToFit()
        }
    }
    
    var isRounding:Bool = false {
        didSet{
            if isRounding {
                bgView.cornerRadius = bgView.frame.height/2
                bgView.clipsToBounds = true
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViewFromXib()
        isRounding = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addViewFromXib()
        isRounding = true
    }
    
}
