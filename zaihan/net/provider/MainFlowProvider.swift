
import Foundation
import Moya
import RxSwift
import RxCocoa

enum MainFlowType {
    case appUpdate(os:String, version:String)
    case emergency
}

extension MainFlowType: TargetType {
    var sampleData: Data {
        
        Data()
    }
    
    var baseURL: URL {
        URL(string: "http://3.35.18.10:4000")!
    }
    
    var path: String {
        switch self {
        case .appUpdate: return "/app/versions/latest"
        case .emergency: return "/management/emergency-system-notice"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .appUpdate(let os, let version):
           
            let params: [String: Any] = [
                "os": os,
                "version": version
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .emergency:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        [:]
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

private let TimeoutClosure = {(endpoint: Endpoint, closure: MoyaProvider<MainFlowType>.RequestResultClosure) -> Void in
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 5
        closure(.success(urlRequest))
    } else {
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}

let mainFlowProvider = MoyaProvider<MainFlowType>(requestClosure: TimeoutClosure)
