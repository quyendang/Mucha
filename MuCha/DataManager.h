//
//  DataManager.h
//  MuCha
//
//  Created by Quyen Dang on 5/1/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Music.h"
@class DataManager;
@protocol DataManagerDelegate <NSObject>

- (void)completeLoadData;

@end
@interface DataManager : NSObject
@property (strong, nonatomic) NSMutableArray *topMusics;
@property (strong, nonatomic) id<DataManagerDelegate> delegate;
@property (strong, nonatomic) NSString *token;
- (void)loadTopMusic;
- (void)searchWithKey:(NSString *)key;
+ (DataManager *)shareInstance;
- (void)getConnectTokenFromAccessToken:(NSString *)token;
- (void)getUserToken;
@end
