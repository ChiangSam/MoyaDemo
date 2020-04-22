//
//  NetManager.swift
//  MoyaMangagerDemo
//
//  Created by Sam Chiang on 2020/4/22.
//  Copyright © 2020 Sam Chiang. All rights reserved.
//
// TODO: 如果 Model 解析层需要替换的话， 变成修改的地方有3个 1，个是 这里转Model的地方， 第二个是 发起请求的地方， 第三个是Model
// 如果 请求返回 和 解析 拆分， 在 Persenter 或者 VM 里面做 可能会更好

import Foundation
import Moya
import ObjectMapper
import Alamofire

// 成功回调
public typealias RequestSuccessCallback = ((_ model: Any?, _ message: String?, _ resposneStr: String) -> Void)
// 失败回调
public typealias RequestFailureCallback = ((_ code: Int?, _ message: String?) -> Void)

public protocol NetManagerProtocol {
    
    
    /// 只需要请成功操作的
    /// - Parameters:
    ///   - api: API 接口
    ///   - success: 请求成功
    ///   - failure: 请求失败或错误
    func request(api: NetApi, success:@escaping RequestSuccessCallback, failure:  RequestFailureCallback?) -> Cancellable?

    
    /// 发起网络请求
    /// - Parameters:
    ///   - api: 后台api接口
    ///   - type: 返回的Model类型
    ///   - success: 请求成功回调
    ///   - failure: 请求失败回调

    @discardableResult
    func request<T: Mappable>(api: NetApi, type: T.Type, success: @escaping RequestSuccessCallback, failure: @escaping RequestFailureCallback) -> Cancellable?
}



class NetManager: NetManagerProtocol{
 
    
    
    public static let shareInstance = NetManager()
    
    private init() {
        
    }

    /**
     Endpoint 配置
     */
    private static let httpEndpointClosure = {(target: MultiTarget) -> Endpoint in
         let timestamp = CLongLong(round(Date().timeIntervalSince1970*1000))
        // 配置请求头信息
         var headers = ["Request-Type":"IOS",
                        "Version":Configs.App.version,
                        "Os-Version":Configs.Device.systemVersion,
                        "Timestamp":"\(timestamp)",
             "Sign":"\(timestamp):IOS:\(Configs.Sign.salt)".hmac(algorithm: .SHA256),
             "Service-name":""]
//         if let loginResult = UserConfig.loginResult() {
//             headers.updateValue(loginResult.accessKey, forKey: "Access-Key")
//             headers.updateValue(loginResult.accessToken, forKey: "Access-Token")
//         }
        let url = target.baseURL.appendingPathComponent(target.path).absoluteString
         let endpoint = Endpoint(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: headers)
         return endpoint
     }
     
     private static let requestClosure =  { (endpoint: Endpoint, done: @escaping MoyaProvider<MultiTarget>.RequestResultClosure) in
         guard var request = try? endpoint.urlRequest() else {
             return
         }
         request.timeoutInterval = 15 //设置请求超时时间
         done(.success(request))
     }
     
     /// 配置网络的插件
     private static var plugins: [PluginType] {
         var plugins: [PluginType] = []
         if Configs.Network.loggingEnabled == true {
            let configuration = NetworkLoggerPlugin.Configuration(logOptions:.verbose)
             plugins.append(NetworkLoggerPlugin(configuration: configuration))
         }
         return plugins
     }
    
    private static let provider = MoyaProvider<MultiTarget>(endpointClosure: NetManager.httpEndpointClosure,requestClosure: NetManager.requestClosure,plugins:  NetManager.plugins)
    
    
    /// Description 带 ObjectMapper JSON字典转Model的请求方法
    /// - Parameters:
    ///   - api: 后台api接口
    ///   - type: 返回的Model类型
    ///   - success: 请求成功回调
    ///   - failure: 请求失败回调
    /// - Returns: 用户页面网络请求取消
    @discardableResult
    func request<T>(api: NetApi, type: T.Type, success: @escaping RequestSuccessCallback, failure: @escaping RequestFailureCallback) -> Cancellable? where T : Mappable {
        // 网络状态监听
        guard NetworkReachabilityManager()?.isReachable ?? false else {
                  return nil
        }
        return NetManager.provider.request( MultiTarget(api)) { (result) in
                            switch result {
                                  case let .success(response):
                                      do {
                                            // 可做状态码判断
                                            let jsonData = try response.mapJSON() // 这里已经和后台协议好，返回的是一个基类
                                        if let result = ReturnResult(JSON: jsonData as? [String: Any] ?? [String: Any]()) {
                                            var model: Any?
                                            if result.data == nil {
                                                success(model, result.msg, response.description)
                                            } else if let dic = result.data as? [String: Any] { // 如果是单个Model
                                                model = T.init(JSON: dic)
                                            } else if let dics = result.data as? [[String: Any]] { // 如果是数组
                                                  model = Mapper<T>().mapArray(JSONArray: dics)
                                            }
                                            success(model, result.msg, response.description)
                                        } else {
                                            failure(0, "解析失败")
                                        }
                                      } catch {
                                       print("JSON 解析异常")
                                    }
                                  case let .failure(error):
                                      // 网络连接失败，提示用户
                                      failure(error.response?.statusCode, error.errorDescription)
                                  }
                        }
      }
    
   func request(api: NetApi, success: @escaping RequestSuccessCallback, failure:  RequestFailureCallback?) -> Cancellable? {
       // 网络状态监听
              guard NetworkReachabilityManager()?.isReachable ?? false else {
                        return nil
              }
              return NetManager.provider.request( MultiTarget(api)) { (result) in
                                  switch result {
                                        case let .success(response):
                                            success(nil, "请求成功", String(data: response.data, encoding: String.Encoding.utf8)!)
                                        case let .failure(error):
                                            // 网络连接失败，提示用户
                                            failure?(error.response?.statusCode, error.errorDescription)
                                        }
                              }
       }
    
}










