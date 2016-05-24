//
//  NSString+Cal.h
//  MuCha
//
//  Created by OSXVN on 5/24/16.
//  Copyright © 2016 Quyen Dang. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreGraphics;
@import UIKit;

@interface NSString (Cal)
- (CGSize)usedSizeForMaxWidth:(CGFloat)width withFont:(UIFont *)font;
@end
