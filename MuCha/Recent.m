//
//  Recent.m
//  MuCha
//
//  Created by OSXVN on 5/17/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import "Recent.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "RecentInbox.h"
@implementation Recent
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.userId = [dic objectForKey:@"senderid"];
        self.lastMessage = [dic objectForKey:@"message"];
        self.roomId = [dic objectForKey:@"senderid"];
    }
    
    return self;
}

- (instancetype)initWithDB:(RecentInbox *)rc{
    self = [super init];
    if (self) {
        self.userId = rc.userid;
        self.roomId = rc.roomid;
        self.lastMessage = rc.lastmessage;
    }
    return self;
}
@end
