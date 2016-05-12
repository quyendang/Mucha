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

@implementation ServiceManager
+ (ServiceManager *)shareInstance{
    static ServiceManager *instance;
    if (instance == nil) {
        instance = [[ServiceManager alloc] init];
    }
    
    return instance;
}

- (void)connectToHostWithToken:(NSString *)token{
    [SIOSocket socketWithHost:[NSString stringWithFormat:@"http://192.168.1.87:3000/?token=%@", token] response: ^(SIOSocket *socket) {
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
             }else{
                 [[DataManager shareInstance].musicLists removeAllObjects];
                 NSError *err;
                 NSData *jsonData = [[args firstObject] dataUsingEncoding:NSUTF8StringEncoding];
                 NSArray *musicArr = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&err];
                 for (NSDictionary *dic in musicArr) {
                     Room *room = [[Room alloc] initWithDictionary:dic];
                     [[DataManager shareInstance].musicLists addObject:room];
                 }
             }
         }];
        [self.socketIO on:@"room" callback: ^(SIOParameterArray *args)
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(socketIO:callBackRoomString:)]) {
                 [self.delegate socketIO:self.socketIO callBackRoomString:[args firstObject]];
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

- (void)createRoomWithMusicId:(NSString *)musicId currentUserId:(NSString *)userId{
    
    NSString *data = [NSString stringWithFormat:@"{\"roomid\" : \"%@\", \"user1\" : \"%@\",\"user2\" : \"%@\" , \"musicid\" : \"%@\" }", [NSString stringWithFormat:@"%@+%@", musicId, userId], userId, @"emty", musicId];
    [self.socketIO emit: @"createroom" args: @[data]];
}
@end
