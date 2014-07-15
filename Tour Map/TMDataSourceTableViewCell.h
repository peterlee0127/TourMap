//
//  TMDataSourceTableViewCell.h
//  Tour Map
//
//  Created by Peterlee on 7/11/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMDataSourceTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) IBOutlet UILabel *urlLabel;
@property (nonatomic,assign) BOOL  enable;
@property (nonatomic,strong) IBOutlet UILabel *statusLabel;


@end
