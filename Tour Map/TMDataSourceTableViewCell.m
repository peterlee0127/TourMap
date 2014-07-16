//
//  TMDataSourceTableViewCell.m
//  Tour Map
//
//  Created by Peterlee on 7/11/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import "TMDataSourceTableViewCell.h"
#import <FXBlurView.h>

@interface TMDataSourceTableViewCell()

@property (nonatomic,strong)  FXBlurView *disableBlur;

@end

@implementation TMDataSourceTableViewCell
- (void)awakeFromNib
{
    // Initialization code
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if(!self.disableBlur)
    {
        self.disableBlur = [[FXBlurView alloc] initWithFrame:self.frame];
        self.disableBlur.blurEnabled = YES;
        self.disableBlur.blurRadius = 22;
        self.disableBlur.backgroundColor = [UIColor whiteColor];
        self.disableBlur.tintColor = [UIColor clearColor];
        UILabel *clicktoEnable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 40)];
        clicktoEnable.text = @"Click to enable this Source";
        clicktoEnable.textColor = [UIColor colorWithWhite:0.557 alpha:1.000];
        clicktoEnable.textAlignment = NSTextAlignmentCenter;
        [self.disableBlur addSubview:clicktoEnable];
        [self.contentView addSubview:self.disableBlur];
    }

    if(!self.enable)
    {
         self.contentView.backgroundColor = [UIColor colorWithWhite:0.926 alpha:1.000];
        [self.disableBlur setHidden:NO];
    }
    else
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.disableBlur setHidden:YES];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
