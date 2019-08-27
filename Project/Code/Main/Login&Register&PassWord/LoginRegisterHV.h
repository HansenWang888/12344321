//  gtp
//
//  Created by Aalto on 2018/12/23.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LoginRegisterHV : UIView

- (void)actionBlock:(DataBlock)block;
//- (void)richElementsInHeaderWithModel:(NSDictionary*)data;
- (instancetype)initWithFrame:(CGRect)frame WithModel:(id)requestParams;
@end
