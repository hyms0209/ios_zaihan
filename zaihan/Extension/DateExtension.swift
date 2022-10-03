//
//  DateExtension.swift
//  zaihan
//
//  Created by lms on 2022/10/03.
//

import Foundation

extension Date {
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
