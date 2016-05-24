//
//  NSString+Cal.m
//  MuCha
//
//  Created by OSXVN on 5/24/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import "NSString+Cal.h"

@implementation NSString (Cal)
- (CGSize)usedSizeForMaxWidth:(CGFloat)width withFont:(UIFont *)font{
    NSTextStorage *textStorage = [[NSTextStorage alloc]
                                  initWithString:self];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize: CGSizeMake(width, MAXFLOAT)];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textStorage addAttribute:NSFontAttributeName value:font
                        range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:0.0];
    
    [layoutManager glyphRangeForTextContainer:textContainer];
    CGRect frame = [layoutManager usedRectForTextContainer:textContainer];
    //NSLog(@"frame %@", frame.size.width);
    return CGSizeMake(ceilf(frame.size.width),ceilf(frame.size.height));
}
@end
