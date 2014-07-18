//
//  TMMenuViewController.m
//  Tour Map
//
//  Created by Peterlee on 7/9/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import "TMMenuViewController.h"
#import <PKRevealController.h>
#import "TMMenuTableViewCell.h"

@interface TMMenuViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *menuArray;


@end

@implementation TMMenuViewController

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
    self.menuArray = @[@"Map",@"List",@"Source",@"About"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, 120,[UIScreen mainScreen].bounds.size.height-20) style:UITableViewStylePlain];
    [self.tableView registerNib:[UINib nibWithNibName:@"TMMenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
     [self.revealController setMinimumWidth:120.0 maximumWidth:124.0 forViewController:self];
    // Do any additional setup after loading the view from its nib.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TMMenuTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    cell.menuLabel.text = [NSString stringWithFormat:@"%@",self.menuArray[indexPath.row]];
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *number = [NSNumber numberWithInt:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeFrontVC" object:number];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
