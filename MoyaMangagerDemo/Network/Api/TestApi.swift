//
//  TestApi.swift
//  MoyaMangagerDemo
//
//  Created by Sam Chiang on 2020/4/22.
//  Copyright © 2020 Sam Chiang. All rights reserved.
//

import Foundation
import Moya

public enum TestApi {
    case hotMovies(start: Int, count: Int)
}

extension TestApi: NetApi {
    public var baseURL: URL {
        return URL(string: "\(Configs.URLConfig.baseUrl)")!
    }
    
    public var path: String {
        switch self {
        case .hotMovies:
            return "v2/movie/in_theaters"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .hotMovies:
            return .get
        default:
            return .get
        }
    }
    
    public var sampleData: Data {
       switch self {
             default:
                 return "".data(using: String.Encoding.utf8)!
      }
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
        case .hotMovies(let start,let count):
        params = ["start": start, "count": count]
        }
        return params
    }
    
    public var task: Task {
         switch self {
               case .hotMovies:
                   return .requestPlain
               default:
                   return .requestParameters(parameters: parameters!, encoding: JSONEncoding.default)
               }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    public var validationType: ValidationType {
        return .none
        
    }
    
    
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}

