//
//  ChatTableViewCell.m
//  MuCha
//
//  Created by OSXVN on 5/12/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell 

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier maxWidth:(CGFloat)maxWidth{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.messageMaxWidth = maxWidth;
        
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier maxSize:(CGSize)maxSize messageType:(BOOL)messageType{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userImage = [[UIImageView alloc] initWithFrame:CGRectMake(!messageType ? self.contentView.frame.size.width - 55.0f : 5.0f, 5.0f, 50.0f, 50.0f)];
        self.userImage.layer.cornerRadius = 25;
        self.userImage.clipsToBounds = YES;
        self.messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(!messageType ? self.contentView.frame.size.width - 80.0f - maxSize.width: 60.0f, 5.0f,maxSize.width + 20.0f, maxSize.height + 20.0f)];
        self.messageTextView.layer.cornerRadius = 20;
        self.messageTextView.clipsToBounds = YES;
        self.messageTextView.backgroundColor = !messageType ? [UIColor colorWithRed:142 / 255.0f green:68 / 255.0f blue:173 / 255.0f alpha:1] : [UIColor grayColor];
        self.messageTextView.textColor = [UIColor whiteColor];
        [self addSubview:self.userImage];
        [self addSubview:self.messageTextView];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
