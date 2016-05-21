//
//  Recent.h
//  MuCha
//
//  Created by OSXVN on 5/17/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RecentInbox;

@interface Recent : NSObject
@property (strong, nonatomic) NSString *roomId;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *userAvatar;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *lastMessage;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
- (instancetype)initWithDB:(RecentInbox *)rc;
@end
