//
//  MainViewModel.swift
//  zaihan
//
//  Created by lms on 2022/09/30.
//

import Foundation
import RxSwift
import RxRelay

protocol MainViewModelType {
    var input:MainViewModelInput { get }
    var output:MainViewModelOutput { get }
}

protocol MainViewModelInput{
    // 카메라 촬영 데이터 처리
    func setCameraPick(key:String, model:HXPhotoModel?)
    // 테스트 코드(마지막 컨텐츠 다시 읽기 - 삭제 테스트)
    func reloadContentData()
    // 테스트 코드(비디오 파일 넘기기)
    func uploadVideoFiles()
    // 카메라 열기
    func openCamera()
    
    // 앨범 열기
    func openAlbum()
    // 앨범 데이터 처리
    func setAlbumPick(key:String, model:HXPhotoModel?)
}

protocol MainViewModelOutput{
    var videoPick:PublishRelay<String>{ get }
    var photoPick:PublishRelay<String>{ get }
    // 카메라 열기
    var cameraInfo:PublishRelay<HXPhotoManager>{ get }
    // 앨범 열기
    var albumInfo:PublishRelay<HXPhotoManager>{ get }
}

class MainViewModel : MainViewModelType, MainViewModelInput, MainViewModelOutput {
    
    
    var input: MainViewModelInput{ self }
    var output: MainViewModelOutput{ self }
    
    var videoPick = PublishRelay<String>()
    var photoPick = PublishRelay<String>()
    var cameraInfo = PublishRelay<HXPhotoManager>()
    
    var albumInfo = PublishRelay<HXPhotoManager>()
    
    var mediaFileManager = MediaFileManager()
    
    var currentKey = ""
    
    // 카메라 촬영 데이터
    func setCameraPick(key:String, model:HXPhotoModel?) {
        // 카메라 비디오 촬영(.video) 또는 편집비디오(.cameraVideo)인 경우 url로 Asset의 이미지를 취득 후 썸네일 정보를 전달한다.
        guard let model = model else { return }
        
        if model.type == .cameraVideo || model.type == .video {
            func sendVideoData(url:URL?) {
                guard let url = url else { return }
                print("vidoe: url : \(String(describing: url.path))")
                self.videoPick.accept(self.getEncodeStringFromVideo(url: url))
                self.mediaFileManager.setMediaItem(key: key, filePath: url.path ?? "", captureType: .Camera, mediaType: .Video)
            }
            // 카메라 직접 촬영 데이터
            if model.type == .cameraVideo {
                var asset = AVAsset(url: model.videoURL!)
                var timeRange = CMTimeRange(start: CMTimeMakeWithSeconds(0.0, preferredTimescale: 0), end: asset.duration)
                
                HXPhotoTools.exportEditVideo(for:asset , timeRange: timeRange, exportPreset: HXVideoEditorExportPreset.highQuality, videoQuality: 8, success: { url in
                    sendVideoData(url:url)
                })
            }
            // 카메라 편집 데이터
            else {
                model.getVideoURL(success: {url,mediaType,isNetwork,model in
                    sendVideoData(url:url)
                })
            }
        } else if model.type == .cameraPhoto || model.type == .photo {

            if let url = model.imageURL {
                self.photoPick.accept(self.getEncodeStringFromPhoto(url:url))
                self.mediaFileManager.setMediaItem(key: key, filePath: url.path ?? "", captureType: .Camera, mediaType: .Photo)
            } else {
                if let asset = model.asset {
                    asset.getURL(completionHandler: { [weak self] url in
                        guard let self = self else { return }
                        self.photoPick.accept(self.getEncodeStringFromPhoto(url:url))
                        self.mediaFileManager.setMediaItem(key: key, filePath: url?.path ?? "", captureType: .Camera, mediaType: .Photo)
                    })
                } else {
                    if let url = saveImageTempFile(image: model.previewPhoto) {
                        self.photoPick.accept(self.getEncodeStringFromPhoto(url:url))
                        self.mediaFileManager.setMediaItem(key: key, filePath: url.path ?? "", captureType: .Camera, mediaType: .Photo)
                    }
                }
            }
        }
        self.currentKey = key
    }
    
    func saveImageTempFile(image:UIImage?) -> URL? {
        guard let image = image else { return nil }
        if let data = image.jpegData(compressionQuality: 0.8) {
            let fileName = NSString.hx_fileName() + ".jpg"
            let path = NSTemporaryDirectory().appending(fileName)
            do {
                let url = URL(fileURLWithPath: path)
                try? data.write(to: url)
                return url
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    // 앨범 데이터
    func setAlbumPick(key:String, model:HXPhotoModel?) {
        // 카메라 비디오 촬영(.video) 또는 편집비디오(.cameraVideo)인 경우 url로 Asset의 이미지를 취득 후 썸네일 정보를 전달한다.
        guard let model = model else { return }
        
        if model.type == .cameraVideo || model.type == .video {
            func sendVideoData(url:URL?) {
                guard let url = url else { return }
                print("vidoe: url : \(String(describing: url.path))")
                self.videoPick.accept(self.getEncodeStringFromVideo(url: url))
                self.mediaFileManager.setMediaItem(key: key, filePath: url.path ?? "", captureType: .Camera, mediaType: .Video)
            }
            
            var asset = AVAsset(url: model.videoURL!)
            var timeRange = CMTimeRange(start: CMTimeMakeWithSeconds(0.0, preferredTimescale: 0), end: asset.duration)
            
            HXPhotoTools.exportEditVideo(for:asset , timeRange: timeRange, exportPreset: HXVideoEditorExportPreset.highQuality, videoQuality: 8, success: { url in
                sendVideoData(url:url)
            })
        } else if model.asset!.mediaType == .image {
            model.asset!.getURL(completionHandler: { [weak self] url in
                guard let self = self else { return }
                var image = UIImage(contentsOfFile: url?.path ?? "")
                if let saveImageUrl = self.saveImageTempFile(image: image) {
                    self.photoPick.accept(self.getEncodeStringFromPhoto(url:saveImageUrl))
                    self.mediaFileManager.setMediaItem(key: key, filePath: saveImageUrl.path ?? "", captureType: .Camera, mediaType: .Photo)
                }
            })
        }
        self.currentKey = key
    }
    
    /**
     *  카메라 정보 취득
     */
    func openCamera() {
        cameraInfo.accept(getManager())
    }
    
    /**
     * 앨범 정보 취득
     */
    func openAlbum() {
        albumInfo.accept(getManager())
    }
    
    /**
     *   비디오 미디어 url로 부터 Base64인코딩 정보 취득
     */
    func getEncodeStringFromVideo(url:URL?) -> String {
        guard let url = url else { return "" }
        return self.getThumbnailImage(forUrl: url)?.getBase64String() ?? ""
    }
    
    /**
     *   이미지 미디어 url로 부터 Base64인코딩 정보 취득
     */
    func getEncodeStringFromPhoto(url:URL?) -> String {
        var ret = ""
        if let url = url , let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                ret =  image.scalePreservingAspectRatio(targetSize: CGSize(width: 100, height: 100)).getBase64String() ?? ""
            }
        }
        return ret
    }
        
     
    func reloadContentData() {
        
        let mediaData = mediaFileManager.getMediaItem(key: self.currentKey)
        // 미디어 파일 삭제
        mediaFileManager.deleteMedia(url: URL(fileURLWithPath: mediaData?.filePath ?? ""))
        
        // 삭제한 미디어 파일로 부터 데이터 취득
        if mediaData?.mediaType == MediaType.Video.rawValue {
            var encodeString = getEncodeStringFromVideo(url: URL(fileURLWithPath: mediaData?.filePath ?? ""))
            print("Reload EncodeString : \(mediaData?.filePath ?? "")")
        } else if mediaData?.mediaType == MediaType.Photo.rawValue {
            var encodeString = getEncodeStringFromPhoto(url: URL(fileURLWithPath: mediaData?.filePath ?? ""))
            print("Reload EncodeString : \(mediaData?.filePath ?? "")")
        }
    }
    
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.maximumSize.width = 200
        imageGenerator.maximumSize.height = 200
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }

        return nil
    }
    
    func uploadVideoFiles() {
        let mediaData = mediaFileManager.getMediaItem(key: self.currentKey)
        momentFlowProvider.rx.request(MomentFlowType.regist(menuId: "menu02",
                                                            categoryId: "categoryId0201",
                                                            subCategoryId: "subCategoryId020101",
                                                            title: "iOS 테스트 파일 업로드입니다.",
                                                            description: "iOS테스트파일업로드 디스크립션",
                                                            images: [],
                                                            video: mediaData?.filePath ?? "")
        )
            .asObservable()
            .mapObject(MomentRegist.Response.self)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                print("모멘트 등록 \(result.message )")

            }, onError: { error in
                
                print("모멘트 오류 : \(error.localizedDescription)")
            }, onCompleted: {
                print("모멘트 완료 ")
            })
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
        
        //navi tint color
        manager.configuration.navigationTitleColor = nil
        //_manager.configuration.navigationTitleColor = [UIColor redColor];
        
        //원본버튼
        //_manager.configuration.hideOriginalBtn = self.hideOriginal.on;
        manager.configuration.hideOriginalBtn = false
        
        //_manager.configuration.filtrationICloudAsset = self.icloudSwitch.on;
        
        //사진 최대 수
        //_manager.configuration.photoMaxNum = self.photoText.text.integerValue;
        manager.configuration.photoMaxNum = 0
        
        //동영상 최대 수
        //_manager.configuration.videoMaxNum = self.videoText.text.integerValue;
        manager.configuration.videoMaxNum = 0
        //전체 최대 수
        //_manager.configuration.maxNum = self.totalText.text.integerValue;
        manager.configuration.maxNum = 1
        
        //사진첩 행 수
        //_manager.configuration.rowCount = self.columnText.text.integerValue;
        
        //클라우드 연결?
        //_manager.configuration.downloadICloudAsset = self.downloadICloudAsset.on;
        
        //내 앨범에 저장(아마 편집 후 말하는 거일듯
        //_manager.configuration.saveSystemAblum = self.saveAblum.on;
        manager.configuration.saveSystemAblum = false
        
        //동영상과 사진 동시에 선택 가능하게
        manager.configuration.selectTogether = false
        
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
        manager.configuration.bottomDoneBtnTitleColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
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
        manager.configuration.cameraPhotoJumpEdit = true
        manager.videoSelectedType = .single
        manager.configuration.singleSelected = true
        manager.type = .photoAndVideo
        
        var language = globalDefaults.language
        if language == "Korean" {
            manager.configuration.languageType = HXPhotoLanguageType.ko;
        }

        //시스템 카메라를 예로 들어 여기에서 사용자 정의 카메라를 사용합니다.
        //manager.configuration.shouldUseCamera = self.shouldUseCamera
        return manager
    }
}
