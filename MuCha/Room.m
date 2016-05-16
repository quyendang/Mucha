//
//  Room.m
//  MuCha
//
//  Created by OSXVN on 5/12/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import "Room.h"
#import "Music.h"

@implementation Room
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.roomId = [dic objectForKey:@"roomid"];
        self.music = [[Music alloc] initWithDataDictionary:dic];
        self.firstUser = [dic objectForKey:@"user1"];
        self.secondUser = [dic objectForKey:@"user2"];
    }
    return self;
}
@end
