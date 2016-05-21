//
//  RecentInbox.h
//  MuCha
//
//  Created by Quyen Dang on 5/19/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Recent.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecentInbox : NSManagedObject
- (void)initWithRecent:(Recent *)recent;
@end

NS_ASSUME_NONNULL_END

#import "RecentInbox+CoreDataProperties.h"
