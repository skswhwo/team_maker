//
//  ImageTableViewCell.m
//  Team
//
//  Created by ChoJaehyun on 2015. 10. 6..
//  Copyright (c) 2015년 Classting. All rights reserved.
//

#import "ImageTableViewCell.h"

@implementation ImageTableViewCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.imageView.layer setCornerRadius:18];
    [self.imageView setFrame:CGRectMake(10, 4, 36, 36)];
    CGRect frame = self.textLabel.frame;
    CGFloat diff = frame.origin.x - 56;
    if(diff > 0) {
        frame.size.width += diff;
    }
    frame.origin.x = 56;
    self.textLabel.frame = frame;
}
@end
