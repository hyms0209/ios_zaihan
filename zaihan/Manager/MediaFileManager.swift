//
//  MediaFileManager.swift
//  zaihan
//
//  Created by lms on 2022/10/01.
//

import Foundation

enum CaptureType : String  {
    case Camera    = "1"
    case Album     = "2"
}

enum MediaType : String {
    case Photo      = "photo"
    case Video      = "video"
}

struct MediaFile : Codable {
    var key         :String?             = ""       // 키값
    var filePath    :String?             = ""       // 파일패스
    var captureType :String?             = CaptureType.Camera.rawValue      // 선택 타입( 카메라 촬영, 앨범에서 선택)
    var mediaType   :String?             = MediaType.Photo.rawValue         // 미디어 종류(앨범, 카메라)
    var makeTime    :String?             = ""
}

struct MediaList:Codable {
    var data:[MediaFile]? = []
}

class MediaFileManager {
    
    var mediaItems:MediaList? = MediaList()
    
    init() {
        loadMediaFile()
    }
    
    /***
     * 미디어 파일 취득
     */
    private func loadMediaFile() {
        if let loadString = globalDefaults.mediaFile {
            if ( loadString.count > 5 ) {
                do {
                    print("Load FileManager")
                    mediaItems = try JSONDecoder().decode(MediaList.self, from: loadString.data(using: .utf8)!)
                    if mediaItems == nil {
                        mediaItems = MediaList()
                    }
                    
                    mediaItems?.data?.forEach { item in
                        print("Load FileManager item : \(item.key):\(item.filePath)")
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

    /***
     * 미디어 파일 저장
     */
    func saveMediaFile() {
        
        do {
            let saveString = try JSONEncoder().encode(self.mediaItems)
            globalDefaults.mediaFile = String(data: saveString, encoding: .utf8)
        } catch  {
            print(error.localizedDescription)
        }
    }

    /***
     * 파일 패스 저장
     */
    func setMediaItem(key:String, filePath:String, captureType:CaptureType ,mediaType:MediaType) {
        var mediaFile = MediaFile(key: key, filePath: filePath, captureType: captureType.rawValue, mediaType: mediaType.rawValue, makeTime: String(Date().getCurrentMillis()))
        self.mediaItems?.data?.append(mediaFile)
        saveMediaFile()
        self.mediaItems?.data?.removeAll()
        loadMediaFile()
    }

    /***
     * 미디어 파일 패스 취득
     */
    func getMediaItemPath(key:String) -> String {
        guard  let item = self.mediaItems?.data?.first(where: {$0.key == key}) else  { return "" }
        return item.filePath ?? ""
    }

    /***
     * 미디어 파일 정보
     */
    func getMediaItem(key:String) -> MediaFile? {
        guard  let item = self.mediaItems?.data?.first(where: {$0.key == key}) else  { return nil }
        return item
    }
    
    /***
     * 미디어 정보 삭제
     */
    func removeMedia(key:String) {
        if let index = self.mediaItems?.data?.firstIndex(where: { $0.key == key}) {
            self.mediaItems?.data?.remove(at: index)
            saveMediaFile()
        }
    }

    /***
     * 미디어 정보 전체 삭제
     */
    func removeAllMedia() {
        self.mediaItems?.data?.removeAll()
        saveMediaFile()
    }

    func deleteMedia(url:URL) -> Bool {
        do {
            try FileManager.default.removeItem(at: url)
            return true
        } catch {
            print("File Delete Error")
        }
        return false
    }
}
