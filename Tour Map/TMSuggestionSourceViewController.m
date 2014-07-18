//
//  TMSuggestionSourceViewController.m
//  Tour Map
//
//  Created by Peterlee on 7/17/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import "TMSuggestionSourceViewController.h"
#import "TMDataSourceTableViewCell.h"
#import <AFNetworking.h>

@interface TMSuggestionSourceViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *suggectionSourceArray;

@end

@implementation TMSuggestionSourceViewController

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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TMDataSourceTableViewCell" bundle:nil] forCellReuseIdentifier:@"SuggestionSourceCell"];
    
    self.navigationController.navigationBar.topItem.title = @"Back";
    self.title = @"Add Template Source";
    // Do any additional setup after loading the view.
}
#pragma mark - UITableView DataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TMDataSourceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SuggestionSourceCell"];
    cell.nameLabel.text = @"";
    cell.urlLabel.text =  @"";
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.suggectionSourceArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
