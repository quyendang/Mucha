//
//  DataManager.h
//  MuCha
//
//  Created by Quyen Dang on 5/1/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Music.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Message.h"
#import "Recent.h"
@class DataManager;
@protocol DataManagerDelegate <NSObject>

- (void)completeLoadData;

@end
@interface DataManager : NSObject
@property (strong, nonatomic) NSMutableArray *topMusics;
@property (strong, nonatomic) NSMutableArray *musicLists;
@property (strong, nonatomic) NSMutableArray *recentChats;
@property (strong, nonatomic) id<DataManagerDelegate> delegate;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *avatarUrl;
@property (assign, nonatomic) BOOL haveARoom;
- (void)loadTopMusic;
- (void)searchWithKey:(NSString *)key;
+ (DataManager *)shareInstance;
- (void)getConnectTokenFromAccessToken:(NSString *)token;
- (void)getUserToken;
- (void)getUserAvataUrl;
- (Music *)musicById:(NSString *)musicId;
- (void)getRecentMessage;
#pragma mark Core data

- (NSArray *)getAllRooms;
- (void)addMessage:(Message *)message;
- (void)addNewRoom:(Recent *)recent;
- (void)deleteRoomById:(NSString *)iD;
- (void)updateLastMessage:(Recent *)message;
@end
