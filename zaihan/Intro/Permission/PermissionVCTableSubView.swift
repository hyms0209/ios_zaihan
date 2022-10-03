//
//  PermissionVC.swift
//  zaihan
//
//  Created by MYONHYUP LIM on 2022/09/03.
//


import UIKit

class PermissionVCTableViewCell: UITableViewCell {
    

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var model: PermissionModel! {
        didSet {
            iconImage.image = model.data.icon
            titleLabel.text = model.data.title
            detailLabel.text = model.data.detail
        }
    }
}

class PermissionVCHeaderView: TableViewHeaderFooterView {
    
    override func initView() {
        super.initView()
        background(color: .clear)
    }
    
    override func setAttributes() {
        super.setAttributes()
        viewLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        viewLabel.font = UIFont(name: "NotoSansCJKKR-Regular", size: 18)
        viewLabel.numberOfLines = 0
        viewLabel.lineBreakMode = .byWordWrapping
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.01

        // Line height: 27 pt
        
        var attributeString = NSMutableAttributedString(string: "재한들이 제공하는 서비스를\n이용하기 위하여 다음 항목들에 대한\n접근 권한 동의가 필요합니다.", attributes: [NSAttributedString.Key.kern: -0.04, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        attributeString.addAttribute(.font, value: UIFont(name: "NotoSansCJKKR-Bold",size:18)!, range: NSRange(location: 35, length:8))
        viewLabel.attributedText = attributeString
                                                                    
  }
    
    override func setConstraints() {
        super.setConstraints()
        guard contentView.constraints.isEmpty else {return}
        NSLayoutConstraint.activate([
            viewLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            viewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            viewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            viewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])

        NSLayoutConstraint.activate([
            viewUnderline.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            viewUnderline.heightAnchor.constraint(equalToConstant: 1),
            viewUnderline.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            viewUnderline.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16),
            viewUnderline.topAnchor.constraint(equalTo: viewLabel.bottomAnchor, constant: 10),
            ])
        
    }
    
}

class PermissionVCFooterView: TableViewHeaderFooterView {
    
    override func initView() {
        super.initView()
        background(color: .clear)
    }
    
    override func setAttributes() {
        super.setAttributes()
        viewLabel.font = UIFont.systemFont(ofSize: 13)
        viewLabel.textColor = UIColor(hex6: "222222")
        viewLabel.textAlignment = .left
        viewLabel.numberOfLines = 0
        viewLabel.lineBreakMode = .byCharWrapping
        viewLabel.text = """
        선택권한에 대해 동의하지 않으셔도 착한페이 앱의 기본 서비스는 이용 하실 수 있습니다.
        
        메뉴 > 설정 > 권한관리에서 관리하실 수 있습니다.
        """
        var range: NSRange = (viewLabel.text! as NSString).range(of: "메뉴 > 설정 > 권한관리")
        let mAttrStr = NSMutableAttributedString(string: viewLabel.text ?? "",
                                                 attributes: [.foregroundColor: UIColor(hex6: "888888"),
                                                              .font: UIFont.systemFont(ofSize: viewLabel.font!.pointSize)])
        mAttrStr.addAttribute(.foregroundColor, value: UIColor(hex6: "222222"), range: range)
        viewLabel.attributedText = mAttrStr
    }
    
    override func setConstraints() {
        super.setConstraints()
        guard contentView.constraints.isEmpty else {return}
        let size = tableView?.bounds.size ?? UIScreen.main.bounds.size
        let hMargin: CGFloat = 45
        let hConst = (hMargin / 375) * size.width
        NSLayoutConstraint.activate([
            viewLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            viewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            viewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: hConst),
            viewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -hConst)
            ])
    }
    
}

