//
//  Message.m
//  MuCha
//
//  Created by OSXVN on 5/12/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import "Message.h"

@implementation Message
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.userID = [dic objectForKey:@"userid"];
        self.senderID = [dic objectForKey:@"senderid"];
        self.message = [dic objectForKey:@"message"];
    }
    
    return self;
}
@end
