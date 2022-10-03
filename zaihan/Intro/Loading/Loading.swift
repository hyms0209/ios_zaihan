


import UIKit


class Loading {
    
    private static let sharedInstance = Loading()
    private var loadingView: UIView?
    
    class func show() {
        let loadingView = UIView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        loadingView.backgroundColor = UIColor.clear
        
        let backView = UIView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        backView.backgroundColor = UIColor.black
        backView.alpha = 0.7
        
        let popupView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: (UIScreen.main.bounds.size.width * 72 / 375), height:  (UIScreen.main.bounds.size.width * 80 / 375)))
        popupView.backgroundColor = UIColor.clear
        popupView.animationImages = Loading.getAnimationImageArray()    // 애니메이션 이미지
        popupView.animationDuration = 1.0
        popupView.animationRepeatCount = 0    // 0일 경우 무한반복
        
        loadingView.addSubview(backView)
        loadingView.addSubview(popupView)
        popupView.center = loadingView.center
        
        // popupView를 UIApplication의 window에 추가하고, popupView의 center를 window의 center와 동일하게 합니다.
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(loadingView)
            loadingView.center = window.center
            popupView.startAnimating()
            sharedInstance.loadingView?.removeFromSuperview()
            sharedInstance.loadingView = loadingView
        }
    }
    
    private class func getAnimationImageArray() -> [UIImage] {
        var animationArray: [UIImage] = []
        let imageList                  = ["loading_01-compressor",
                                         "loading_02-compressor",
                                         "loading_03-compressor",
                                         "loading_04-compressor",
                                         "loading_05-compressor",
                                         "loading_06-compressor",
                                         "loading_07-compressor",
                                         "loading_08-compressor",
                                         "loading_09-compressor",
                                         "loading_10-compressor",
                                         "loading_11-compressor",
                                         "loading_12-compressor",
                                         "loading_13-compressor",
                                         "loading_14-compressor",
                                         "loading_15-compressor",
                                         "loading_16-compressor",
                                         "loading_17-compressor",
                                         "loading_18-compressor",
                                         "loading_19-compressor",
                                         "loading_20-compressor",
                                         "loading_21-compressor",
                                         "loading_22-compressor",
                                         "loading_23-compressor",
                                         ]
        animationArray =  imageList.map{UIImage(named: $0)!}
        return animationArray
    }
    
    class func close() {
        if let loadingView = sharedInstance.loadingView {
            
            (loadingView.subviews[1] as! UIImageView).stopAnimating()
            loadingView.removeFromSuperview()
        }
    }
}
