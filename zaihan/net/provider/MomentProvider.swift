//
//  MomentProvider.swift
//  zaihan
//
//  Created by lms on 2022/10/03.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

enum MomentFlowType {
    case regist(menuId:String, categoryId:String, subCategoryId:String, title:String, description:String,images:[String], video:String)
    case push(token:String)
}

extension MomentFlowType: TargetType {
    var sampleData: Data {
        Data()
    }
    
    var baseURL: URL {
        URL(string: "http://3.35.18.10:4000")!
    }
    
    var path: String {
        switch self {
        case .regist: return "/board/posts/regist"
        case .push: return "/management/emergency-system-notice"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        switch self {
        case .regist(let menuId, let categoryId, let subCategoryId, let title, let description, let images, let video):
            let params: [String: Any] = [
                "menuId"        : menuId,
                "categoryId"    : categoryId,
                "subCategoryId" : subCategoryId,
                "title"         : title,
                "description"   : description,
                "images"        : images,
//                "video"         : URL(fileURLWithPath: video).lastPathComponent + ";type=" + URL(fileURLWithPath: video).mimeTypeForPath()
            ]
            
            var multiPartData: [Moya.MultipartFormData] = []
            do {
                let videoUrl = URL(fileURLWithPath: video)
                let videoData:Data = try Data(contentsOf: videoUrl, options: .mappedIfSafe)
                let name = String(videoUrl.lastPathComponent.split(separator: ".")[0])
                let fileName = videoUrl.lastPathComponent
                let mimeType = videoUrl.mimeTypeForPath()
               
                let multipart = Moya.MultipartFormData(provider: .file(videoUrl),
                                                        name: "video",
                                                        fileName: fileName,
                                                        mimeType: mimeType)
                let menuId = MultipartFormData(provider: .data(menuId.data(using: .utf8)!), name: "menuId")
                let categoryId = MultipartFormData(provider: .data(categoryId.data(using: .utf8)!), name: "categoryId")
                let title = MultipartFormData(provider: .data(title.data(using: .utf8)!), name: "title")
                let subCategoryId = MultipartFormData(provider: .data(subCategoryId.data(using: .utf8)!), name: "subCategoryId")
                let description = MultipartFormData(provider: .data(description.data(using: .utf8)!), name: "description")
                
                multiPartData.append( multipart)
                multiPartData.append( menuId)
                multiPartData.append( categoryId)
                multiPartData.append( title)
                multiPartData.append( subCategoryId)
                multiPartData.append( description)
                
                
            } catch {
                print(error.localizedDescription)
            }
            return .uploadMultipart(multiPartData)
//            return .uploadCompositeMultipart(multiPartData, urlParameters: params)
        case .push(let token):
            let params: [String: Any] = [
                "token"        : token,
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        [   "accept":"*/*",
            "Content-Type":"application/json",
            "Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhbGljZSIsInJvbGUiOiJ1c2VyIiwiaWF0IjoxNjY0Nzk5OTczLjAyOCwiZXhwIjoxNjY0ODAzNTczfQ.x2tdzKg1J9JIebbLz-bZF9QgzC5owSDj7czYLsmTPR8"]
    }
}

private func JSONResponseDataFormatter(_ data: Data) -> String {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
    } catch {
        return String(data: data, encoding: .utf8) ?? ""
    }
}

private let TimeoutClosure = {(endpoint: Endpoint, closure: MoyaProvider<MomentFlowType>.RequestResultClosure) -> Void in
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 5
        closure(.success(urlRequest))
    } else {
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}

let momentFlowProvider = MoyaProvider<MomentFlowType>(requestClosure: TimeoutClosure)

