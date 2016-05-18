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
#import "DataManager.h"
#import "Room.h"
#import "ChatViewController.h"
#import "Recent.h"

@implementation ServiceManager
+ (ServiceManager *)shareInstance{
    static ServiceManager *instance;
    if (instance == nil) {
        instance = [[ServiceManager alloc] init];
    }
    
    return instance;
}

- (void)connectToHostWithToken:(NSString *)token{
    [DataManager shareInstance].recentChats = [[NSMutableArray alloc] init];
    [SIOSocket socketWithHost:[NSString stringWithFormat:@"http://quyen23.cloudapp.net:3000/?token=%@", token] response: ^(SIOSocket *socket) {
        self.socketIO = socket;
        self.socketIO.onConnect = ^(){
            NSLog(@"User connected");
            self.isLogin = YES;
            [self joinSocketWithUserId:[FBSDKAccessToken currentAccessToken].userID];
        };
        [self.socketIO on: @"chat" callback: ^(SIOParameterArray *args)
         {
             if ([self.delegate isKindOfClass:[ChatViewController class]] && self.delegate && [self.delegate respondsToSelector:@selector(socketIO:callBackString:)]) {
                 [self.delegate socketIO:self.socketIO callBackString:[args firstObject]];
             }else{
                 NSError *jsonError;
                 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[[args firstObject] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&jsonError];
                 Recent *recent = [[Recent alloc] initWithDictionary:dic];
                 [[DataManager shareInstance].recentChats addObject:recent];
             }
         }];
        [self.socketIO on:@"room" callback: ^(SIOParameterArray *args)
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(socketIO:callBackRoomString:)]) {
                 [self.delegate socketIO:self.socketIO callBackRoomString:[args firstObject]];
             }else{
                 
             }
         }];
        self.socketIO.onError = ^(NSDictionary *errorInfo){
            NSLog(@"%@", errorInfo);
        };
    }];
}

- (void)sendMessage:(NSString *)mess{
    [self.socketIO emit: @"chat" args: @[mess]];
}

- (void)joinSocketWithUserId:(NSString *)userID{
    [self.socketIO emit: @"join" args: @[userID]];
}

- (void)createRoomWithMusic:(Music *)music currentUserId:(NSString *)userId{
    
    NSString *data = [NSString stringWithFormat:@"{\"roomid\" : \"%@\", \"user1\" : \"%@\",\"user2\" : \"%@\" , \"musicid\" : \"%@\", \"title\" : \"%@\",\"username\" : \"%@\",\"avataUrl\" : \"%@\", \"streamUrl\" : \"%@\" }", [NSString stringWithFormat:@"%@+%@", music.musicId, userId], userId, @"emty", music.musicId, music.title, music.username, music.avataUrl, music.streamUrl];
    [self.socketIO emit: @"createroom" args: @[data]];
}
@end
