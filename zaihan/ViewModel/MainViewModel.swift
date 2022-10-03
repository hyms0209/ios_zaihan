//
//  MainViewModel.swift
//  zaihan
//
//  Created by lms on 2022/09/30.
//

import Foundation
import RxSwift
import RxRelay
import HXPhotoPicker

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
}

protocol MainViewModelOutput{
    var videoPick:PublishRelay<String>{ get }
    var photoPick:PublishRelay<String>{ get }
}

class MainViewModel : MainViewModelType, MainViewModelInput, MainViewModelOutput {
    
    
    var input: MainViewModelInput{ self }
    var output: MainViewModelOutput{ self }
    
    var videoPick = PublishRelay<String>()
    var photoPick = PublishRelay<String>()
    
    var mediaFileManager = MediaFileManager()
    
    var currentKey = ""
    
    // 카메라 촬영 데이터
    func setCameraPick(key:String, model:HXPhotoModel?) {
        // 카메라 비디오 촬영(.video) 또는 편집비디오(.cameraVideo)인 경우 url로 Asset의 이미지를 취득 후 썸네일 정보를 전달한다.
        if model?.type == .cameraVideo || model?.type == HXPhotoModelMediaType.video {
            
            if let url = model?.videoURL {
                self.videoPick.accept(self.getEncodeStringFromVideo(url: url))
                self.mediaFileManager.setMediaItem(key: key, filePath: url.path, captureType: .Camera, mediaType: .Video)
            } else {
                model?.asset?.getURL(completionHandler: { [weak self] url in
                    guard let self = self else { return }
                    
                    self.videoPick.accept(self.getEncodeStringFromVideo(url:url))
                    self.mediaFileManager.setMediaItem(key: key, filePath: url?.path ?? "", captureType: .Camera, mediaType: .Video)
                })
            }
        } else if model?.asset?.mediaType == .image {
            model?.asset?.getURL(completionHandler: { [weak self] url in
                guard let self = self else { return }
                self.photoPick.accept(self.getEncodeStringFromPhoto(url:url))
                self.mediaFileManager.setMediaItem(key: key, filePath: url?.path ?? "", captureType: .Camera, mediaType: .Photo)
            })
        }
        self.currentKey = key
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
                
                self.mediaFileManager.deleteMedia(url: URL(fileURLWithPath: mediaData?.filePath ?? ""))
                self.mediaFileManager.removeMedia(key: mediaData?.key ?? "")
                self.mediaFileManager.setMediaFile()
            }, onError: { error in
                
                print("모멘트 오류 : \(error.localizedDescription)")
            }, onCompleted: {
                print("모멘트 완료 ")
            })
    }

}
