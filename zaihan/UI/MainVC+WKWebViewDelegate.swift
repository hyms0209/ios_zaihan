//
//  MainVC+WKWebViewDelegate.swift
//  zaihan
//
//  Created by MYONHYUP LIM on 2022/09/04.
//

import Foundation
import WebKit


var zaihanIf = ["zaihanif"]

extension MainVC : WKUIDelegate, WKNavigationDelegate {
    
    /**
     *  웹뷰의 URL이 거쳐가는 경로 이곳에서 URL을 이동 시킬지 네이티브 처리를 할지 결정
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else { decisionHandler(.cancel); return }
        if url.scheme == "http" || url.scheme ==  "https"{
            // url이 네이티브에서 여는작업이 아닌 경우, webView에서 열리도록 .allow
            decisionHandler(.allow)
        } else {
            // 재한 웹뷰 인터페이스인 경우
            if zaihanIf.contains("zaihanif") {
//                CommonPopupVC.present(self, type: .one, configuration: {
//                    $0.titleText = "재한 인터페이스"
//                    $0.detailText = "재한 인터페이스로 넘어온 URL입니다."
//                    $0.oneBtnSelected = {[weak self] in
//                        guard let self = self else { return }
//                    }
//                })
                openCamera()
            } else {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            decisionHandler(.cancel)
            return
        }
    }
}
