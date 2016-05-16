//
//  Music.h
//  MuCha
//
//  Created by Quyen Dang on 5/1/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Music : NSObject
@property (strong, nonatomic) NSString *musicId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *avataUrl;
@property (strong, nonatomic) NSString *streamUrl;
@property (strong, nonatomic) NSData *data;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
- (instancetype)initWithMusicId:(NSString *)musicId;
- (instancetype)initWithDataDictionary:(NSDictionary *)dic;
@end
