//
//  ReturnResult.swift
//  MoyaMangagerDemo
//
//  Created by Sam Chiang on 2020/4/22.
//  Copyright © 2020 Sam Chiang. All rights reserved.
//

import Foundation
import ObjectMapper

class ReturnResult: NSObject, Mappable {
    /// 状态码
    var code = 0
    /// 系统返回消息
    var msg = ""
    
    /// 返回的数据
    var data: Any?
    
    // 和后台协议接口，比如 Page 等字段是否需要
    
    override init() {
         super.init()
     }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        code <- map["code"]
        msg <- map["msg"]
    }

}
