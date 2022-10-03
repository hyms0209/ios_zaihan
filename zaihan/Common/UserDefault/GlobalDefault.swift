//
//  GlobalDefault.swift
//  zaihan
//
//  Created by MyongHyupLim on 11/12/2018.
//  Copyright © 2022  All rights reserved.
//


import Foundation
import UIKit


/// 로컬에 저장되야하는 기본정보들 모음
let globalDefaults = GlobalDefaults()

enum UserType: String {
    case None = "N"
    case Guest = "U"
    case Member = "G"
}

class GlobalDefaults{
    
    let defaults = UserDefaults.standard


    //푸시 토큰 정보
    var pushToken: String? {
        set { setValue(newValue as AnyObject?,key: "pushToken") }
        get { return getString("pushToken",defaultValue: "") }
    }
    
    var permissionComplete: Bool {
        set { setValue(newValue as AnyObject?, key: "permissionComplete")}
        get { return getBool("permissionComplete", defaultValue: false) }
    }
    
    var language:String? {
        set { setValue(newValue as AnyObject?,key: "language") }
        get { return getString("language",defaultValue: "Korean") }
    }
    
    var mediaFile:String? {
        set { setValue(newValue as AnyObject?,key: "mediaFile") }
        get { return getString("mediaFile",defaultValue: "") }
    }
    
    ////////////////////////////// wrapper 함수 /////////////////
    func setValue(_ value: AnyObject?, key:String, defaultValue: AnyObject? = nil) {
        var v = value
        if value == nil {
            v = defaultValue
        }
        if let val = v as? String {
            v = AES256Util.encrypt(data: val) as AnyObject
        } else if let val = v as? Bool {
            v = AES256Util.encrypt(data: "\(val)") as AnyObject
        } else if var val = v as? [String] {
            for i in 0 ..< val.count {
                val[i] = AES256Util.encrypt(data: val[i])
            }
            v = val as AnyObject
        } else if let val = v as? Int {
            v = AES256Util.encrypt(data: "\(val)") as AnyObject
        }
        
        defaults.set(v, forKey:AES256Util.encrypt(data: key))
        defaults.synchronize()
    }
    
    func setInt(_ value: AnyObject?, key:String, defaultValue: AnyObject? = nil) {
        var v = value
        if value == nil {
            v = defaultValue
        }
        
        if let val = v as? Int {
            v = AES256Util.encrypt(data: "\(val)") as AnyObject
        }
        defaults.set(v, forKey:AES256Util.encrypt(data: key))
        defaults.synchronize()
    }
    
    func getBool(_ k: String, defaultValue: Bool? = false) -> Bool {
        let key = AES256Util.encrypt(data: k)
        if defaults.object(forKey: key) == nil && defaultValue != nil {
            return defaultValue!
        }
        
        return AES256Util.decrypt(encoded: defaults.string(forKey: key)!) == "\(true)"
    }
    
    func getString(_ k: String, defaultValue: String? = nil) -> String? {
        let key = AES256Util.encrypt(data: k)
        if let v =  defaults.string(forKey: key) {
            return AES256Util.decrypt(encoded: v)
        } else {
            return defaultValue
        }
    }
    
    func getInt(_ k:String, defaultValue: Int? = nil) -> Int? {
        let key = AES256Util.encrypt(data: k)
        if let v =  defaults.string(forKey: key) {
            return Int(AES256Util.decrypt(encoded: v))
        } else {
            return defaultValue
        }
    }
    
    func getStringList(_ k: String) -> [String]? {
        let key = AES256Util.encrypt(data: k)
        if var v =  defaults.object(forKey: key) as? [String] {
            for i in 0 ..< v.count {
                v[i] = AES256Util.decrypt(encoded: v[i])
            }
            return v
        } else {
            return nil
        }
    }
    
    
    func reset() {
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
    }
}
