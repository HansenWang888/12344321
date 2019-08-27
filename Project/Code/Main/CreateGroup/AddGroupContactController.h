//
//  AddGroupContactController.h
//  ProjectXZHB
//
//  Created by 汤姆 on 2019/7/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum {
    //    添加群成员
    ControllerType_add,
    //    删除群成员
    ControllerType_delete
    
}ControllerType;
/**
 添加或者删除自建群的成员
 */
@interface AddGroupContactController : UIViewController

/**
 群id
 */
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, assign) ControllerType type;

@end


