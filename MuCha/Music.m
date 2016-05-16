//
//  Music.m
//  MuCha
//
//  Created by Quyen Dang on 5/1/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import "Music.h"
#import "DataManager.h"

@implementation Music
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.title = [dic objectForKey:@"title"];
        //NSLog(@"%@", self.title);
        self.username = [[dic objectForKey:@"user"] objectForKey:@"username"];
        self.avataUrl = [[dic objectForKey:@"user"] objectForKey:@"avatar_url"];
        self.streamUrl = [dic objectForKey:@"stream_url"];
        self.musicId = [dic objectForKey:@"id"];
    }
    
    return self;
}

- (instancetype)initWithMusicId:(NSString *)musicId{
    self = [super init];
    if (self) {
        //self = [[DataManager shareInstance] musicById:musicId];
        self.musicId = musicId;
    }
    return self;
}

- (instancetype)initWithDataDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.title = [dic objectForKey:@"title"];
        //NSLog(@"%@", self.title);
        self.username = [dic objectForKey:@"username"];
        self.avataUrl = [dic objectForKey:@"avataUrl"];
        self.streamUrl = [dic objectForKey:@"streamUrl"];
        self.musicId = [dic objectForKey:@"musicid"];
    }
    
    return self;
}
@end
