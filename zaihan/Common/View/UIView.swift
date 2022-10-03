//
//  UIView.swift
//  zaihan
//
//  Created by MYONHYUP LIM on 2022/09/03.
//

import UIKit

extension UIView {
    
    /// 자신의 class name을 unique Id로 사용하기 위해 string 객체로 return 한다.
    static var identifier: String {
        return String(describing: self)
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        } set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        } set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    
    func addViewFromXib() {
        let metaType = type(of: self)
        let bundle = Bundle(for: metaType)
        let nib = UINib(nibName: String(describing: metaType), bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }
    }
    
    /*
     뷰가 UITextField, UITextView 일때 firstResponder가 된다면
     키보드를 내릴 수 있는 "done" 버튼을 가진 toolBar를 inputAccessoryView에 붙여준다.
     */
    open override func becomeFirstResponder() -> Bool {
        let tvStatus = (self is UITextView) && (self as! UITextView).isEditable
        if (self is UITextField || tvStatus) && inputAccessoryView == nil {
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: bounds.size.width, height: 25))
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
            toolbar.setItems([flexSpace, doneBtn], animated: false)
            toolbar.sizeToFit()
            (self is UITextField)
                ? ((self as! UITextField).inputAccessoryView = toolbar)
                : ((self as! UITextView).inputAccessoryView = toolbar)
        }
        return super.becomeFirstResponder()
    }
    
    /// Application에 resignFirstResponder를 하라고 sendAction을 한다.
    @objc private func doneButtonAction() {
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
