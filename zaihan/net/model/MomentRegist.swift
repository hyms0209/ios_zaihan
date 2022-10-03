//
//  MomentRegist.swift
//  zaihan
//
//  Created by lms on 2022/10/03.
//

import Foundation

enum MomentRegist {
    
    // MARK: - BannerResponse
    struct Response: Codable {
        var code: String?
        var timestamp:String?
        var method:String?
        var name: String?
        var message: String?
        var stack: String?
        
        var data: Content? = Content()
    }
    
    // MARK: - Content
    struct Content: Codable {
        var id: String?
        var createdAt :String?
    }
}
