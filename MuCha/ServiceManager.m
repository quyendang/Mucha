//
//  ServiceManager.m
//  MuCha
//
//  Created by OSXVN on 5/7/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import "ServiceManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation ServiceManager
+ (ServiceManager *)shareInstance{
    static ServiceManager *instance;
    if (instance == nil) {
        instance = [[ServiceManager alloc] init];
    }
    
    return instance;
}

- (void)connectToHostWithToken:(NSString *)token{
    [SIOSocket socketWithHost:[NSString stringWithFormat:@"http://localhost:3000/?token=%@", token] response: ^(SIOSocket *socket) {
        self.socketIO = socket;
        self.socketIO.onConnect = ^(){
            NSLog(@"User connected");
            self.isLogin = YES;
            [self joinSocketWithUserId:[FBSDKAccessToken currentAccessToken].userID];
        };
        [self.socketIO on: @"chat" callback: ^(SIOParameterArray *args)
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(socketIO:callBackString:)]) {
                 [self.delegate socketIO:self.socketIO callBackString:[args firstObject]];
             }
         }];
    }];
}

- (void)sendMessage:(NSString *)mess{
    [self.socketIO emit: @"chat" args: @[mess]];
}

- (void)joinSocketWithUserId:(NSString *)userID{
    [self.socketIO emit: @"join" args: @[userID]];
}
@end
