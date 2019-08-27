//
//  NotificationCellModel.swift
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/23.
//  Copyright © 2019 CDJay. All rights reserved.
//

import HandyJSON

class NotificationCellModel: HandyJSON {

    var title: String?
    
    var content: String?
    
    var time: String?
    
    var isRead: Bool?
    
    /**
     * 是否被展开
     */
    var isStretch: Bool = false;
    
    required init() {}
    
    func calculateCellheight() -> CGFloat {
        let origiHeight:CGFloat = 78;

        if isStretch == false || self.content?.length == 0 || self.content == nil {
            return origiHeight;
        }
        
        let width: CGFloat = kScreenWidth - 30 - 40;
        
        
        let contentHeight = self.content?.getTextHeigh(font: UIFont.systemFont(ofSize: 12), width: width);
       
        let cellHeight = origiHeight + contentHeight!;
        return cellHeight;
        
    }
    
}
