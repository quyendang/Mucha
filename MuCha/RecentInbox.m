//
//  RecentInbox.m
//  MuCha
//
//  Created by Quyen Dang on 5/19/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import "RecentInbox.h"

@implementation RecentInbox

// Insert code here to add functionality to your managed object subclass
- (void)initWithRecent:(Recent *)recent{
    self.roomid = recent.roomId;
    self.userid = recent.userId;
    self.username = @"dummy";
    self.useravatar = @"dummy";
    self.lastmessage = recent.lastMessage;
}
@end
