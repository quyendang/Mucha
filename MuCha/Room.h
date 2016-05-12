//
//  Room.h
//  MuCha
//
//  Created by OSXVN on 5/12/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Music;

@interface Room : NSObject
@property (strong, nonatomic) NSString *roomId;
@property (strong, nonatomic) Music *music;
@property (strong, nonatomic) NSString *secondUser;
@property (strong, nonatomic) NSString *firstUser;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
