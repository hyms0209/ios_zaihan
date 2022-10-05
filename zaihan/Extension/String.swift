//
//  StringExtension.swift
//  zaihan
//
//  Created by lms on 2022/10/03.
//

import Foundation

extension String {
    
    func getFileUrl() -> URL {
        return URL(fileURLWithPath: self)
    }
}
