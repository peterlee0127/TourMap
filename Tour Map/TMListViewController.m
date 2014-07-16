//
//  TMListViewController.m
//  Tour Map
//
//  Created by Peterlee on 7/9/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import "TMListViewController.h"
#import "TMListTableViewCell.h"
#import "TMAppDelegate.h"

@interface TMListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *listTableView;

@end

@implementation TMListViewController

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
    self.title =@"Place List";
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    [self.listTableView registerNib:[UINib nibWithNibName:@"TMListTableViewCell" bundle:nil] forCellReuseIdentifier:@"ListCell"];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    [self.view addSubview:self.listTableView];
    
    // Do any additional setup after loading the view from its nib.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TMListTableViewCell *cell =[self.listTableView dequeueReusableCellWithIdentifier:@"ListCell"];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d",indexPath.row);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
