//
//  AppDelegate.swift
//  zaihan
//
//
//  Created by MyongHyupLim on 11/12/2018.
//  Copyright © 2022  All rights reserved.
//


import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    open var viewController:UIViewController?
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        application.applicationIconBadgeNumber = 0
        
        URLCache.shared.removeAllCachedResponses()
        
 
        UNUserNotificationCenter.current().delegate = self
        
        if let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary {
            self.application(application, didReceiveRemoteNotification: userInfo as! [AnyHashable : Any])
        }
        
        RealNetworkMonitor.shared.startMornitoring()
        
        return true
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    

    // 푸시 등록 성공
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // String타입으로 변경 변경
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        globalDefaults.pushToken = deviceTokenString
        self.sendPushInfo(token:deviceTokenString)
        
        print("APNs device token: \(deviceTokenString)")
    }
    
    // 푸시 등록 실패
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //print("APNs registration failed: \(error)")
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        // 앱이 기동중인 경우 팝업으로 알림을 준다.
        if application.applicationState == .active {
            if #available(iOS 10.0, *) {
                self.remotePushProcess(userInfo: userInfo)
            } else {
                if let aps = userInfo[AnyHashable("aps")]! as? NSDictionary {
                    if let alert = aps["alert"]! as? NSDictionary {
                        guard let title = alert["title"] as? String else { return }
                        guard let body = alert["body"] as? String else { return }
                        self.remotePushProcess(userInfo: userInfo)

                    }
                }
            }
        } else {
            self.remotePushProcess(userInfo: userInfo)
        }
    }
    
    /**
     * 푸시로 부터 넘어온 데이터처리
     * @param nil
     * @returns nil
     */
    func remotePushProcess(userInfo: [AnyHashable : Any]) {
        // url이 존재하는 경우만 처리한다.
        guard let url = userInfo["landingUrl"] as? String else { return }
        guard let decodeUrl = url.removingPercentEncoding else { return }
        
        self.processScheme(url: URL(string: decodeUrl)!)
    }
    
    var status = 0
    /**
     * 백그라운드 진입
     * @param
     * @returns
     */
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        makeLockSplash()
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        status = 1
        cleanLockSplash()

    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0

    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0

    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    let TAG_LOCK_SPLASH = 10101
    func cleanLockSplash() {
        self.window?.rootViewController?.view.viewWithTag(TAG_LOCK_SPLASH)?.removeFromSuperview()
    }
    
    func makeLockSplash() {
        self.window?.rootViewController?.view.viewWithTag(TAG_LOCK_SPLASH)?.removeFromSuperview()
        
        let bgView = UIView(frame: self.window!.bounds)
        bgView.tag = TAG_LOCK_SPLASH
        bgView.backgroundColor = UIColor.white
        
        let fileName = "r_a_splash)"
        let bgImg = UIImageView(image: UIImage(named: fileName))
        
        bgImg.frame = bgView.bounds
        bgView.addSubview(bgImg)
        
        self.window!.rootViewController?.view.addSubview(bgView)
    }
    
    /**
     *  스킴을 입력하여 들어온 경우
     * @param url 외부스킴에서 들어온 URL
     * @returns true : 성공처리 false : 실패처리
     */
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        processScheme(url: url)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        processScheme(url: url)
        return false
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        processScheme(url: url)
        return true
    }
    
    /**
     * 외부 스킴으로 들어오는 메시지 처리
     * @param nil
     * @returns nil
     */
    func processScheme(url:URL) {
        DispatchQueue.main.async {
            if UIApplication.shared.applicationState == .active {
                //UrlHandlerManager.sharedInstance.processLocalScheme(url)
            } else {
                //UrlHandlerManager.sharedInstance.processScheme(url)
            }
//            print("scheme in =====> \(url.absoluteString)")
        }
    }
    
    func sendPushInfo(token:String) {
        
    }

}

extension UIApplication {
    @objc class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}
