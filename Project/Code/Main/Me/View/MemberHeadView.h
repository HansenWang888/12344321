//
//  MemberHeadView.h
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberHeadView : UIButton
@property(nonatomic,strong)UIButton *zuanQianBtn;
@property(nonatomic,strong)UIButton *zhangDanBtn;
@property(nonatomic,strong)UIButton *yuEBaoBtn;

- (void)update;

@end
