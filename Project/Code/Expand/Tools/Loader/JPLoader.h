//
//  JSPatch.h
//  JSPatch
//
//  Created by bang on 15/11/14.
//  Copyright (c) 2015 bang. All rights reserved.
//

#import <Foundation/Foundation.h>

const static NSString *rootUrl = @"";

static NSString *publicKey = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDqBFkoAbJ8T87MO0oTzd4ukJ0H\n2uRJafT2oglG7PPQKiOM/B2DRV+pkVoqAC1ra7p8FtUMaCnG8/xA9RaJfip0rs46\nGd9BodVrUg6Ag+gm3W/+qn/BXe6UjAJfgHydoG6J1x0mkJ2ubJ06QExY/RVcr3cp+7I/k8Oafx0trrGWewIDAQAB\n-----END PUBLIC KEY-----";

typedef void (^JPUpdateCallback)(NSError *error);

typedef enum {
    JPUpdateErrorUnzipFailed = -1001,
    JPUpdateErrorVerifyFailed = -1002,
} JPUpdateError;

@interface JPLoader : NSObject
+ (BOOL)run;
+ (void)updateToVersion:(NSInteger)version loadURL:(NSString*)loadURL callback:(JPUpdateCallback)callback;
+ (void)runTestScriptInBundle;
+ (void)setLogger:(void(^)(NSString *log))logger;
+ (NSInteger)currentVersion;
@end
