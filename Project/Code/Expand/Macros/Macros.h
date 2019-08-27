//
//  Macros.h
//  Project
//
//  Created by Mike on 2019/1/13.
//  Copyright © 2019 CDJay. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#define kWeakself(self) __weak __typeof(self)weakSelf = self
#import "DYMacro.h"
#define kColorWithHex(hex) [UIColor colorWithRed:((float)((hex & 0xff0000) >> 16))/255.0 green:((float)((hex & 0x00ff00) >> 8))/255.0 blue:((float)(hex & 0x0000ff))/255.0 alpha:1.0]

#define kThemeTextColor kColorWithHex(0xe41c27)

#endif /* Macros_h */
