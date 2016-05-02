//
//  Music.m
//  MuCha
//
//  Created by Quyen Dang on 5/1/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import "Music.h"

@implementation Music
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.title = [dic objectForKey:@"title"];
        //NSLog(@"%@", self.title);
        self.username = [[dic objectForKey:@"user"] objectForKey:@"username"];
        self.avataUrl = [[dic objectForKey:@"user"] objectForKey:@"avatar_url"];
        self.streamUrl = [dic objectForKey:@"stream_url"];
        dispatch_queue_t que = dispatch_queue_create("Load Image", nil);
        dispatch_async(que, ^{
            self.data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.avataUrl]];
        });
    }
    
    return self;
}
@end
