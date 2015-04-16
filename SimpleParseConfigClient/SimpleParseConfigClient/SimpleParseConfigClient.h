//
//  SimpleParseConfigClient.h
//  SimpleParseConfigClient
//
//  Created by Le Huy on 4/16/15.
//  Copyright (c) 2015 Huy Le. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleParseConfigClient : NSObject
@property NSDictionary* appConfig;

// Global init, used for Parse Server
+ (void) setAppId:(NSString*) appId;// This is App ID on Parse Settings
+ (void) setAPIKey:(NSString*) apiKey;// This is REST API KEYS on Parse Settings

// Singleton instance
+ (instancetype) sharedInstance;

// Get config from server
- (void) requestConfigOnCompleted:(void (^)(NSDictionary* app)) onCompleted;
@end
