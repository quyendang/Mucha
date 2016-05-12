//
//  MusicViewController.h
//  MuCha
//
//  Created by Quyen Dang on 5/1/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicViewController;

@protocol MusicViewControllerDelegate <NSObject>
- (void)serverResponseRoom;
@end
@interface MusicViewController : UIViewController
@property (strong, nonatomic) id<MusicViewControllerDelegate> delegate;
@end
