//
//  ContactsModel.swift
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/24.
//  Copyright © 2019 CDJay. All rights reserved.
//

import HandyJSON

/**
 * 客服和好友模型
 */
@objcMembers class ContactsModel: HandyJSON {
    
    
    var avatar: String?
    
    var chatId: String?
    
    var nick: String?
    
    var userId: String?
    /**
     * 0 == 客服  1 == 好友
     */
    var type: Int = 0;
    
    /**
     * 0 == 离线  1 == 在线
     */
    var status: Int = 0;
    
    required init() {
        
    }

}
