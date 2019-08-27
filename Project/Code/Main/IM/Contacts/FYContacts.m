//
//  Contacts.m
//  Project
//
//  Created by Mike on 2019/6/20.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FYContacts.h"

@implementation FYContacts

MJCodingImplementation

- (id)initWithPropertiesDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if (dic != nil) {
            
            self.userId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"userId"]];
            self.nick = [dic objectForKey:@"nick"];
            self.avatar = [dic objectForKey:@"avatar"];
            self.sessionId = [dic objectForKey:@"chatId"];
            
            self.name = [dic objectForKey:@"nick"];
            
        }
    }
    
    return self;
}


@end
