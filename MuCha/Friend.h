//
//  Friend.h
//  MuCha
//
//  Created by OSXVN on 5/7/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userLink;
@property (strong, nonatomic) NSString *userFirstName;
@property (strong, nonatomic) NSString *userLastName;
@property (strong, nonatomic) NSString *userPicture;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
