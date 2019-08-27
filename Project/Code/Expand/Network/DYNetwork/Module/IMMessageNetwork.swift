//
//  IMMessageNetwork.swift
//  Project
//
//  Created by fangyuan on 2019/8/20.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

/**
 * 即时通讯消息功能 相关接口
 */
class IMMessageNetwork: DYBaseNetwork {

    
    /**
     * 获取消我加入的群组列表
     */
    class func getMyGroupList(_ pageIndex: Int, pageSize: Int) -> IMMessageNetwork {
        
        let obj = IMMessageNetwork.init();
        
        obj.dy_baseURL = AppModel.shareInstance()!.serverUrl;
        obj.dy_requestUrl = "social/skChatGroup/joinGroupPage";
        obj.dy_requestArgument = [
                "size":pageSize,
                "sort":"id",
                "isAsc":"false",
                "current":pageIndex
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        return obj;
        
    }
    
    /**
     * 根据群组id获取群组信息
     */
    class func getGroupInfo(groupId: String) -> IMMessageNetwork {
        let obj = IMMessageNetwork.init();
        
        obj.dy_baseURL = AppModel.shareInstance()!.serverUrl;
        obj.dy_requestUrl = "social/skChatGroup/";
        obj.dy_requestArgument = [
            "id":groupId
        ];
        obj.dy_requestMethod = .POST;
        obj.dy_requestSerializerType = .JSON;
        return obj;
        
    }
}
