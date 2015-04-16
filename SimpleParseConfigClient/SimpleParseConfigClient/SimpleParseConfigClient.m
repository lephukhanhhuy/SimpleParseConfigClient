//
//  SimpleParseConfigClient.m
//  SimpleParseConfigClient
//
//  Created by Le Huy on 4/16/15.
//  Copyright (c) 2015 Huy Le. All rights reserved.
//

#import "SimpleParseConfigClient.h"

#define kUserKeyCachingConfig @"kUserKeyCachingConfig"

@interface SimpleParseConfigClient()
@property NSString* appId;
@property NSString* apiKey;
@end

@implementation SimpleParseConfigClient
static NSString* appId = nil;
static NSString* apiKey = nil;
+ (void) setAppId:(NSString*) appId_ {
    appId = appId_;
}
+ (void) setAPIKey:(NSString*) apiKey_ {
    apiKey = apiKey_;
}

static SimpleParseConfigClient* _sharedInstance = nil;
+ (instancetype) sharedInstance {
    NSAssert(appId != nil, @"Please use setAppId first, it may on your AppDelegate");
    NSAssert(apiKey != nil, @"Please use setAPIKey first, it may on your AppDelegate");
    if (_sharedInstance == nil) {
        _sharedInstance = [SimpleParseConfigClient new];
        // This is Class App on Parse admin
        _sharedInstance.appId = appId;
        _sharedInstance.apiKey = apiKey;
        _sharedInstance.appConfig = [[NSUserDefaults standardUserDefaults] objectForKey:kUserKeyCachingConfig];
    }
    return _sharedInstance;
}
- (void) requestConfigOnCompleted:(void (^)(NSDictionary* app)) onCompleted {
    NSString* serverAddress = @"https://api.parse.com/1/config";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverAddress]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    [request addValue:self.appId forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request addValue:self.apiKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([data length] > 0 && error == nil) {
                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"receivedData (NSDictionary): %@", dict);
                if (onCompleted) {
                    self.appConfig = dict[@"params"];
                    [[NSUserDefaults standardUserDefaults] setObject:self.appConfig forKey:kUserKeyCachingConfig];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    onCompleted(self.appConfig);
                    return;
                }
            }
            else if ([data length] == 0 && error == nil)
                NSLog(@"Empty reply");
            else if (error != nil && error.code == NSURLErrorTimedOut)
                NSLog(@"Timeout");
            else if (error != nil)
                NSLog(@"Error: %@", error);
            onCompleted(nil);
        });
    }];
}
@end
