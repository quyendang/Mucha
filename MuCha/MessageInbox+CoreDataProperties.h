//
//  MessageInbox+CoreDataProperties.h
//  MuCha
//
//  Created by Quyen Dang on 5/19/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MessageInbox.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageInbox (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *roomid;
@property (nullable, nonatomic, retain) NSString *userid;
@property (nullable, nonatomic, retain) NSString *message;

@end

NS_ASSUME_NONNULL_END
