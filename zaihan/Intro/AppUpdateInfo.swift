//
//  AppUpdateInfo.swift
//  KT GoodPay
//
//  Created by 임명협 on 2018. 6. 4..
/*
 * KT GoodPay version 1.0
 *
 *  Copyright ⓒ 2019 kt corp. All rights reserved.
 *
 *  This is a proprietary software of kt corp, and you may not use this file except in
 *  compliance with license agreement with kt corp. Any redistribution or use of this
 *  software, with or without modification shall be strictly prohibited without prior written
 *  approval of kt corp, and the copyright notice above does not evidence any actual or
 *  intended publication of such software.
 */


import Foundation
import UIKit

class AppUpdateInfo {
    
    var delegate: FlowManageDelegate?
    var context: UIViewController?

    func start() {

//        guard let info = Bundle.main.infoDictionary else {
//            self.delegate?.onNext(.appUpdate, param: nil)
//            return
//        }
//        let currentVersion = info["CFBundleShortVersionString"] as? String
//
//        let req = APIUpdateCheck.Request()
//        req.version             = currentVersion!
//        req.os                  = "IOS"
//
//        APIUpdateCheck(withAnimation: false).request(param: req, callback: { (response: ResponseOBJ?) in
//            if ((response?.isSuccess())!) {
//                let res  = response as! APIUpdateCheck.Response
//                guard let serVer = res.appVersion as? String else {
//                    self.delegate?.onCancel(.appUpdate)
//                    return
//                }
//
//                guard let mandatory = res.mandatory as? String else {
//                    self.delegate?.onCancel(.appUpdate)
//                    return
//
//                }
//
//                // 서버의 버젼이 높은 경우 업데이트 진행( 강제 또는 일반 )
//                if currentVersion! < serVer {
//                    Analytics.setScreenName("AUETCPO0202", screenClass: String(describing: type(of: self))) // 강제 버전업 / 재설치
//                    let vc = UIApplication.topViewController()!
//                    // 강제업데이트인 경우
//                    if mandatory.uppercased() == "Y" {
//                        // 팝업 노출 후 앱스토어로 이동
//                        CommonPopupVC.present(vc, type: .two) {
//                            $0.detailText = "서비스 이용을 위해서는 앱업데이트가 필요합니다.\n지금 업데이트 하시겠습니까?"
//                            $0.cancelTitle = "종료"
//                            $0.cancelBtnSelected = {exit(0)}
//                            $0.okTitle = "업데이트"
//                            $0.okBtnSelected = {self.goMarket()}
//                        }
//                    } else {
//                        // 팝업 노출 후 선택에 따라 이동 분기
//                        CommonPopupVC.present(vc, type: .two) {
//                            $0.detailText = "신규 업데이트 항목이 있습니다.\n지금 업데이트 하시겠습니까?"
//                            $0.cancelTitle = "취소"
//                            $0.cancelBtnSelected = {self.delegate?.onNext(.appUpdate, param: nil)}
//                            $0.okTitle = "확인"
//                            $0.okBtnSelected = {self.goMarket()}
//                        }
//                    }
//                } else {
//                    self.delegate?.onNext(.appUpdate, param: nil)
//                }
//            } else {
//                if (response?.retmsg) != nil {
////                    print("\(String(describing: response?.retmsg))")
//                }
//                self.delegate?.onCancel(.appUpdate)
//            }
//        })
        
    }
    
    func goMarket() {
        let url = URL(string: "itms-apps://itunes.apple.com/app/itunes-u/id1450475439?mt=8")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!)
        }
    }
}
