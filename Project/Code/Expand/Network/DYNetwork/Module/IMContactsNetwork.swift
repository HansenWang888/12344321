//
//  IMContactsNetwork.swift
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/24.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

/**
 * 通讯录相关接口
 */
@objcMembers class IMContactsNetwork: DYBaseNetwork {
    
    /**
     * 获取在线客服列表
     */
    static func getContacts() -> IMContactsNetwork {
        
        let obj = IMContactsNetwork.init();
        obj.dy_baseURL = AppModel.shareInstance()!.serverUrl;
        obj.dy_requestUrl = "social/friend/getContact";
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        return obj;
        
    }

}
