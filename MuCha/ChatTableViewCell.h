//
//  ChatTableViewCell.h
//  MuCha
//
//  Created by OSXVN on 5/12/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTableViewCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
//@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (nonatomic) CGFloat messageMaxWidth;
@property (strong, nonatomic) UIImageView *userImage;
@property (strong, nonatomic) UITextView *messageTextView;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier maxWidth:(CGFloat)maxWidth;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier maxSize:(CGSize)maxSize messageType:(BOOL)messageType;
@end
