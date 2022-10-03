//
//  UITableHeaderFooterView.swift
//  zaihan
//
//  Created by MYONHYUP LIM on 2022/09/03.
//

import Foundation
import UIKit

class TableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    weak var tableView: UITableView?
    let viewLabel = UILabel()
    let viewUnderline = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initView()
        setAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
        setAttributes()
    }
    
    func initView() {
        contentView.addSubview(viewLabel)
        contentView.addSubview(viewUnderline)
    }
    
    func setAttributes() {
        viewLabel.adjustsFontSizeToFitWidth = true
        viewLabel.minimumScaleFactor = 0.5
        
        viewUnderline.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1)
        viewUnderline.backgroundColor = UIColor.init(hex6: "#E6E6E6")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
    }
    
    func setConstraints() {
        viewLabel.translatesAutoresizingMaskIntoConstraints = false
        viewUnderline.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func background(color: UIColor) {
        let bView = UIView(frame: contentView.bounds)
        bView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bView.backgroundColor = color
        backgroundView = bView
        contentView.backgroundColor = color
    }
    
}
