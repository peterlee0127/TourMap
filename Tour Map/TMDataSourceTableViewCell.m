//
//  TMDataSourceTableViewCell.m
//  Tour Map
//
//  Created by Peterlee on 7/11/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import "TMDataSourceTableViewCell.h"

@implementation TMDataSourceTableViewCell
{
    UIView *disableBlur;
}

- (void)awakeFromNib
{
    // Initialization code
}
-(void)layoutSubviews
{
    if(!disableBlur)
    {
        disableBlur = [[UIView alloc] initWithFrame:self.frame];
        disableBlur.alpha = 0.8f;
        disableBlur.backgroundColor = [UIColor whiteColor];
        disableBlur.tintColor = [UIColor clearColor];
        [self.contentView addSubview:disableBlur];
    }

    if(!self.enable)
    {
         self.contentView.backgroundColor = [UIColor colorWithWhite:0.926 alpha:1.000];
        [disableBlur setHidden:NO];
    }
    else
    {
        [disableBlur setHidden:YES];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
