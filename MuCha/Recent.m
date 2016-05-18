//
//  Recent.m
//  MuCha
//
//  Created by OSXVN on 5/17/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import "Recent.h"

@implementation Recent
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.userId = [dic objectForKey:@"senderid"];
        self.lastMessage = [dic objectForKey:@"message"];
    }
    
    return self;
}
@end
