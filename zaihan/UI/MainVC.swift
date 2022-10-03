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
    
    private var viewModel:MainViewModelType = MainViewModel()
    
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
            
            
    }

    func openCamera() {
        let vc = HXCustomCameraViewController()
        vc.delegate = self
        vc.manager = getManager()
        vc.isOutside = true
        vc.isEditing = true
        
        hx_presentCustomCameraViewController(with: getManager()) {[weak self] model, cameraviewcontroller in
            guard let self = self else { return }
            self.viewModel.input.setCameraPick(key: "12345", model: model)
        }
    }
    
    func getManager() -> HXPhotoManager {
        let manager = HXPhotoManager.init()
        
        manager.configuration.clarityScale = 1.4;
        manager.configuration.exportVideoURLForHighestQuality = true
        manager.configuration.customCameraType = .photoAndVideo
        
        
        
        //테마 색상
        //_manager.configuration.themeColor = self.view.tintColor;
        //_manager.configuration.themeColor = [UIColor redColor];
        
        
        //셀 선택시 색상
        manager.configuration.cellSelectedTitleColor = UIColor.red
        
        
        //네비 색상 관련
        manager.configuration.navBarBackgroudColor = nil
        manager.configuration.statusBarStyle = UIStatusBarStyle.default

        manager.configuration.cellSelectedBgColor = nil
        manager.configuration.selectedTitleColor = nil
        manager.configuration.previewRespondsToLongPress = longPress
        //navi tint color
        manager.configuration.navigationTitleColor = nil
        //_manager.configuration.navigationTitleColor = [UIColor redColor];
        
        //원본버튼
        //_manager.configuration.hideOriginalBtn = self.hideOriginal.on;
        manager.configuration.hideOriginalBtn = true
        
        //_manager.configuration.filtrationICloudAsset = self.icloudSwitch.on;
        
        //사진 최대 수
        //_manager.configuration.photoMaxNum = self.photoText.text.integerValue;
        manager.configuration.photoMaxNum = 6
        
        //동영상 최대 수
        //_manager.configuration.videoMaxNum = self.videoText.text.integerValue;
        manager.configuration.videoMaxNum = 1
        //전체 최대 수
        //_manager.configuration.maxNum = self.totalText.text.integerValue;
        manager.configuration.maxNum = 6
        
        //사진첩 행 수
        //_manager.configuration.rowCount = self.columnText.text.integerValue;
        
        //클라우드 연결?
        //_manager.configuration.downloadICloudAsset = self.downloadICloudAsset.on;
        
        //내 앨범에 저장(아마 편집 후 말하는 거일듯
        //_manager.configuration.saveSystemAblum = self.saveAblum.on;
        manager.configuration.saveSystemAblum = false
        
        //동영상과 사진 동시에 선택 가능하게
        manager.configuration.selectTogether = true
        
        //사진 편집 기능
        manager.configuration.photoCanEdit = true
        
        //동영상 편집 기능
        manager.configuration.videoCanEdit = true
        
        //선택 완료 이후 이미지 가져오기
        manager.configuration.requestImageAfterFinishingSelection = true
        
        //카메라 켜기
        manager.configuration.replaceCameraViewController = true
        manager.configuration.openCamera = true
        
        
        manager.configuration.themeColor = UIColor(hex6: "#000000")
        
        //사진 선택시 숫자 색과 배경
        manager.configuration.cellSelectedTitleColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1)
        manager.configuration.cellSelectedBgColor = UIColor.init(red: 255, green: 30, blue: 30, alpha: 1)
        
        //보기 편집 원본이미지 등 아래 배경 색상
        manager.configuration.bottomViewBgColor = UIColor.init(red: 215, green: 30, blue: 30, alpha: 1)
        
        manager.configuration.bottomDoneBtnBgColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1)
        manager.configuration.bottomDoneBtnTitleColor = UIColor.init(red: 255, green: 30, blue: 30, alpha: 1)
        manager.configuration.bottomDoneBtnEnabledBgColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 0)   //선택된 사진이 없을때 버튼 백그라운드 컬러
        manager.configuration.bottomDoneBtnDarkBgColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1)    //선택된 사진이 있을때 버튼 백그라운드 컬러
        manager.configuration.originalBtnImageTintColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1)
        
        manager.configuration.navBarBackgroudColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1)
        manager.configuration.navigationTitleColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        manager.configuration.navigationTitleArrowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        
        //사진 크게보기에서 네비바에 위치한 선택버튼 색
        manager.configuration.previewSelectedBtnBgColor = UIColor.init(red: 215, green: 30, blue: 30, alpha: 1)
        //사진 크게보기에서 아래 선택된 사진 테두리 색
        manager.configuration.previewBottomSelectColor = UIColor.init(red: 255, green: 255, blue: 0, alpha: 0.5)
        
        manager.configuration.showBottomPhotoDetail = true
        
        manager.configuration.videoMaximumDuration = 30.0
        manager.configuration.videoMaximumSelectDuration = 30
        manager.configuration.maxVideoClippingTime = 30
        
        var language = globalDefaults.language
        if language == "Korean" {
            manager.configuration.languageType = HXPhotoLanguageType.ko;
        }


        
        //시스템 카메라를 예로 들어 여기에서 사용자 정의 카메라를 사용합니다.
        manager.configuration.shouldUseCamera = self.shouldUseCamera
        return manager
    }
    
    func shouldUseCamera(vc:UIViewController?, cameraType:HXPhotoConfigurationCameraType, manager:HXPhotoManager? ) {

        let pickerControll = UIImagePickerController()
        pickerControll.delegate = self;
        pickerControll.allowsEditing = false;
        var arrMediaTypes:[String] = [];
        if (cameraType == HXPhotoConfigurationCameraType.photo) {
            arrMediaTypes.append(kUTTypeImage as String)
        }else if (cameraType == HXPhotoConfigurationCameraType.video) {
            arrMediaTypes.append(kUTTypeMovie as String)
        }else {
            arrMediaTypes.append(kUTTypeImage as String)
        }
        pickerControll.mediaTypes = arrMediaTypes
        pickerControll.videoQuality = UIImagePickerController.QualityType.typeHigh
        pickerControll.videoMaximumDuration = 30.0
        pickerControll.sourceType = UIImagePickerController.SourceType.camera
        pickerControll.navigationController?.navigationBar.tintColor = UIColor.white
        pickerControll.modalPresentationStyle = .overCurrentContext
        vc?.present(pickerControll, animated: false, completion: nil)
    }
    
    func longPress(longPress:UILongPressGestureRecognizer?, photomodel:HXPhotoModel?, manager:HXPhotoManager?, previewViewController:HXPhotoPreviewViewController?) {
        print("\(photomodel)")
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

