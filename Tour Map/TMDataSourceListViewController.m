//
//  TMDataSourceListViewController.m
//  Tour Map
//
//  Created by Peterlee on 7/11/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import "TMDataSourceListViewController.h"
#import "TMDataSourceTableViewCell.h"
#import <FXBlurView.h>

@interface TMDataSourceListViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation TMDataSourceListViewController

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
    self.title =@"DataSource";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [self.tableView registerNib:[UINib nibWithNibName:@"TMDataSourceTableViewCell" bundle:nil] forCellReuseIdentifier:@"DataSourceList"];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
  
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view from its nib.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TMDataSourceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DataSourceList"];
    
    cell.nameLabel.text = @"TW";
    cell.urlLabel.text = @"url";
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FXBlurView *headerView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    headerView.blurEnabled = YES;
    headerView.dynamic = YES;
    headerView.blurRadius =12;
    headerView.tintColor = [UIColor clearColor];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(55 , 10, 200, 40)];
    [addButton setTitle:@"Add more DataSource" forState:UIControlStateNormal];
    addButton.titleLabel.textColor = [UIColor blackColor];
    addButton.backgroundColor = [UIColor clearColor];
    [addButton addTarget:self action:@selector(addSource) forControlEvents:UIControlEventTouchDown];
    [headerView addSubview:addButton];
    
    return headerView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
#pragma mark - AddSource
-(void) addSource
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    alert.title = @"Input your DataSource URL";
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].text = @"http://";
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeURL];
    [alert addButtonWithTitle:@"Done"];
    [alert addButtonWithTitle:@"Cancel"];

    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1) // Cancel
        return;
    
    UITextField *urlField = [alertView textFieldAtIndex:0];
    NSURL *url = [NSURL URLWithString:urlField.text];
    NSLog(@"%@",url);
    
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
