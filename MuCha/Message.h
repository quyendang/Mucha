//
//  Message.h
//  MuCha
//
//  Created by OSXVN on 5/12/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *senderID;
@property (strong, nonatomic) NSString *message;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
