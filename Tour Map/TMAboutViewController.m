//
//  TMAboutViewController.m
//  Tour Map
//
//  Created by Peterlee on 7/14/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import "TMAboutViewController.h"

@interface TMAboutViewController ()

@end

@implementation TMAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"About this App";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
