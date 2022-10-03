//
//  VersionInfo.swift
//  zaihan
//
//  Created by lms on 2022/10/03.
//

import Foundation

enum AppUpdate {
    
    // MARK: - BannerResponse
    struct Response: Codable {
        var code: String?
        var message: String?
        var data: Content?
    }
    
    // MARK: - Content
    struct Content: Codable {
        var os: String?
        var version: String?
        var status: String?
    }
}
