//
//  Config.swift
//  MoyaMangagerDemo
//
//  Created by Sam Chiang on 2020/4/21.
//  Copyright © 2020 Sam Chiang. All rights reserved.
//

import Foundation
import UIKit

struct Configs {
    
    struct Device {
           /// 系统版本
           static let systemVersion = UIDevice.current.systemVersion
           /// 系统名称
           static let systemName = UIDevice.current.systemName
           /// 设备类型
           static let model = UIDevice.current.model
           // 设备手机型号
           //    static let deviceModelName = UIDevice.current.modelName
           /// 设备名称
           static let name = UIDevice.current.name
       }
    
    // 配置应用信息
    struct App {
        /// 应用版本
        static let version = "\(String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!))"
        
        /// 应用BuildVersion
        static let buildVersion = NSString(string: String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion"))).integerValue
        
        /// 应用BundleId
        static let bundleID = "\(String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") ?? ""))"
        
        /// 应用名
        static let displayName = "\(String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") ?? ""))"
        
        #if DEBUG
        static let mode = "DEBUG"
        #else
        static let mode = "Release"
        #endif
    }
    
    // 配置网络相关信息
    struct Network {
           /// 是否开启Log日志
           static let loggingEnabled = true
    }
    
    // 配置签名认证信息
    struct Sign {
          static let salt = ""
      }
    
    struct URLConfig {
        static let baseUrl = "https://douban.uieee.com" // 这里用豆瓣的测试一下
        static let imageUrl = ""
    }
}
