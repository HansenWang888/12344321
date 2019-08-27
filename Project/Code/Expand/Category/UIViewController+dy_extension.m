//
//  UIViewController+dyExtension.m
//  ID贷
//
//  Created by apple on 2019/6/20.
//  Copyright © 2019 hansen. All rights reserved.
//

#import "UIViewController+dy_extension.h"

@implementation UIViewController (dy_extension)


+ (instancetype)dy_initWithVCString:(NSString *)vcStr {
    
    Class class;
    
    @try {
        class = NSClassFromString(vcStr);
    } @catch (NSException *exception) {
        NSLog(@"dyLog -----%@", exception);
        return nil;
    }
    UIViewController *vc = [class new];
    
    return vc;
}
@end
