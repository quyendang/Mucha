//
//  Friend.m
//  MuCha
//
//  Created by OSXVN on 5/7/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import "Friend.h"

@implementation Friend
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.userID = [dic objectForKey:@"id"];
        self.userName = [dic objectForKey:@"name"];
        self.userLink = [dic objectForKey:@"link"];
        self.userFirstName = [dic objectForKey:@"first_name"];
        self.userLastName = [dic objectForKey:@"last_name"];
        self.userPicture = [[[dic objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
    }
    
    return self;
}
@end
