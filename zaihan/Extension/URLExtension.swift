//
//  URLExtension.swift
//  zaihan
//
//  Created by lms on 2022/10/03.
//

import Foundation
import AVFoundation
import MobileCoreServices

extension URL {
    func mimeTypeForPath() -> String {
        let url = NSURL(fileURLWithPath: self.path)
        let pathExtension = url.pathExtension

        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return ""
    }
}
