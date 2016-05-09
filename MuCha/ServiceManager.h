//
//  ServiceManager.h
//  MuCha
//
//  Created by OSXVN on 5/7/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SIOSocket.h>
@class ServiceManager;
@protocol ServiceManagerDelegate <NSObject>

- (void)socketIO:(SIOSocket *)socket callBackString:(NSString *)messeage;

@end
@interface ServiceManager : NSObject
@property (strong, nonatomic) SIOSocket *socketIO;
@property (strong, nonatomic) id<ServiceManagerDelegate> delegate;
@property (assign, nonatomic) BOOL isLogin;
+ (ServiceManager *)shareInstance;
- (void)connectToHostWithToken:(NSString *)token;
- (void)sendMessage:(NSString *)mess;
@end
