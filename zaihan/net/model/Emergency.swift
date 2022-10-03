//
//  Emergency.swift
//  zaihan
//
//  Created by MYONHYUP LIM on 2022/09/03.
//

import Foundation

enum Emergency {
    
    // MARK: - BannerResponse
    struct Response: Codable {
        var code: String?
        var message: String?
        var data: Content?
    }
    
    // MARK: - Content
    struct Content: Codable {
        var id: String?
        var title: String?
        var description: String?
        var shutdownStartAt :String?
        var shutdownEndAt : String?
        var isShutdown : Bool
    }
}
