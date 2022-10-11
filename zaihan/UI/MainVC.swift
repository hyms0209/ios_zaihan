//
//  MainVC.swift
//  zaihan
//
//  Created by MYONHYUP LIM on 2022/09/03.
//

import Foundation
import UIKit
import WebKit
import HXPhotoPicker
import Photos
import RxSwift

class MainVC: UIViewController, HXCustomCameraControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    @IBOutlet weak var btnReload: UIButton!
    
    static func instance() -> MainVC {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as! MainVC
    }
    
    public static var mInstance:MainVC? = nil
    
    var viewModel:MainViewModelType = MainViewModel()
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var imgThumbnail: UIImageView!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        MainVC.mInstance = self
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        if let url = URL(string: "https://hyms0209.github.io") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        bindViewModel()
//        UrlHandlerManager.sharedInstance.mainActivated = true
//        UrlHandlerManager.sharedInstance.processUrl()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func bindViewModel() {
        // 카메라 촬영 후 비디오 정보 수신시
        viewModel.output.videoPick
            .subscribe(onNext:{[weak self] encodeString in
                guard let self = self else { return }
                self.webView.evaluateJavaScript("setImageByteCode('data:image/png;base64,\(encodeString)')")
            }).disposed(by: self.disposeBag)
        
        // 카메라 촬영 후 이미지 정보 수신시
        viewModel.output.photoPick
            .subscribe(onNext:{[weak self] encodeString in
                guard let self = self else { return }
                self.webView.evaluateJavaScript("setImageByteCode('data:image/png;base64,\(encodeString)')")
            }).disposed(by: self.disposeBag)
            
        // 카메라 매니저 정보 취득
        viewModel.output.cameraInfo
            .subscribe(onNext:{[weak self] manager in
                guard let self = self else { return }
                self.openCamera(manager)
            }).disposed(by: self.disposeBag)
            
        // 앨범 매니저 정보 취득
        viewModel.output.albumInfo
            .subscribe(onNext:{[weak self] manager in
                guard let self = self else { return }
                self.openAlbum(manager)
            }).disposed(by: self.disposeBag)
    }

    
    
    @IBAction func onReload(_ sender: Any) {
        viewModel.input.uploadVideoFiles()
    }
}

extension MainVC : HXCustomCameraViewControllerDelegate {
    func customCameraViewController(_ viewController: HXCustomCameraViewController!, didDone model: HXPhotoModel!) {
        print("HXCustomCameraViewControllerDelegate : \(model)")
    }
}

