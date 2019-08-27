//
//  SVProgressHUD+CDHUD.h
//  Project
//
//  Created by mini on 2018/8/3.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "SVProgressHUD.h"

@interface SVProgressHUD (CDHUD)

#define SVP_SHOW [SVProgressHUD show]
#define SVP_SUCCESS_STATUS(a) [SVProgressHUD showSuccessWithStatus:a]
#define SVP_ERROR_STATUS(a) [SVProgressHUD showErrorWithStatus:a]
#define SVP_ERROR(a)  [SVProgressHUD showError:a]
#define SVP_DISMISS [SVProgressHUD dismiss]
#define SVP_PROGRESS(a,b) [SVProgressHUD showProgress:a status:b]
#define SVP_SHOW_STATUS(a)  [SVProgressHUD showWithStatus:a]

+ (void)showError:(NSError *)error;

@end
