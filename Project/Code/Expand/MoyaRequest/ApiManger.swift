//
//  DMAPI.swift
//  RS
//
//  Created by Aalto on 2018/1/5.
//  Copyright © 2018年 Aalto. All rights reserved.
//  moya的一个具体的接口实现

import Foundation
import Moya

enum  ApiManger {
    //排行榜
    case rankList
    case getAppendRankList(String)
    case postParamsRankList(param: String,param2:String)
    case postloginList(param: Dictionary<String, Any>)

}

// 补全【MoyaConfig 3：配置TargetType协议可以一次性处理的参数】中没有处理的参数
extension ApiManger: TargetType {
    /**
     0.配置TargetType协议可以一次性处理的参数
     
     - Todo: 个别baseURL不同，个别配
     
     **/
    var baseURL: URL {
        switch self {
        case .rankList:
            return URL(string: "http://app.u17.com/v3/appV3_3/ios/phone/")!
        default:
            return URL(string: "http://10.10.95.35:16000/")!
        }
        
    }
    
    //1. 每个接口的相对路径
    //请求时的绝对路径是   baseURL + path
    var path: String {
        switch self {
        case .rankList:
            return "rank/list"
            
        case .getAppendRankList(let id):
            return "rank/list\(id)"
            
        case .postParamsRankList:
            return "rank/list"
            
        case .postloginList:
            return "auth/nauth/mobile/token"
        }
    }

    //2. 每个接口要使用的请求方式
    var method: Moya.Method {
        switch self {
        case .rankList:
            return .post
            
        case .getAppendRankList:
            return .get
            
        case .postParamsRankList:
            return .post
            
        case .postloginList:
            return .post
        }
    }

    //3. Task是一个枚举值，根据后台需要的数据，选择不同的http task。
    
    var task: Task {
        var params: [String: Any] = [:]
        switch self {
        case .rankList:
            return .requestPlain
            
        case let .postParamsRankList(param,param2)://
            params["param"] = param
            params["param2"] = param2
        
        case let .postloginList(param):
            params = param
            
        default:
            //不需要传参数的接口走这里
            return .requestPlain
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
    /*
     JSONEncoding.default是放在HttpBody内的，   比如post请求
     URLEncoding.default在GET中是拼接地址的，    比如get请求
    JSONEncoding的主要作用是把参数以JSON的形式编码到request之中，当然是通过request的httpBody进行赋值的。JSONEncoding提供了两种处理函数，一种是对普通的字典参数进行编码，另一种是对JSONObject进行编码
     */
    
    // 定义请求头，可以加上数据类型，cookie等信息
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
//        return "{}".data(using: String.Encoding.utf8)!
        switch self {
            //        case .Show:
        //            return "[{\"userId\": \"1\", \"Title\": \"Title String\", \"Body\": \"Body String\"}]".data(using: String.Encoding.utf8)!
        case .rankList:
            return "Create post successfully".data(using: String.Encoding.utf8)!
            
        default:
            return "".data(using: String.Encoding.utf8)!
            
        }
    }
}

