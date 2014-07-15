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
#import "TMAppDelegate.h"
#import <CoreData/CoreData.h>
#import "Source.h"
#import "TMDataManager.h"

@interface TMDataSourceListViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *sourceArray;

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
    UIBarButtonItem *updateBarButton  =[[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(updateAllSource)];
    
    [self fetchDataSource];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [self.tableView registerNib:[UINib nibWithNibName:@"TMDataSourceTableViewCell" bundle:nil] forCellReuseIdentifier:@"DataSourceList"];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
  
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view from its nib.
}
-(void) fetchDataSource
{
    TMAppDelegate *delegate = (TMAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Source" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"url" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    self.sourceArray = [context executeFetchRequest:request error:&error];
    
    [self.sourceArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Source *tempSource = (Source *)obj;
        NSLog(@"%@-%@ %@",tempSource.name,tempSource.url,tempSource.enable);
    }];
}
#pragma mark - UITableView DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TMDataSourceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DataSourceList"];
    Source *source = self.sourceArray[indexPath.row];
    cell.nameLabel.text = source.name;
    cell.urlLabel.text = source.url;
    if(![source.enable boolValue])
        cell.backgroundColor = [UIColor grayColor];
    else
        cell.backgroundColor = [UIColor clearColor];
    
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
    return self.sourceArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

#pragma mark - UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Source *tempSource=self.sourceArray[indexPath.row];
   
    TMAppDelegate *delegate = (TMAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"Source"];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"url==%@",tempSource.url]; // If required to fetch specific vehicle
    fetchRequest.predicate=predicate;
    Source *source=[[context executeFetchRequest:fetchRequest error:nil] lastObject];
    
    [source setValue:@(![source.enable boolValue]) forKey:@"enable"];
 
    
    [context save:nil];
    [self fetchDataSource];
    [self.tableView reloadData];
    
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
    [[TMDataManager shareInstance] downloadData:urlField.text];

    TMAppDelegate *delegate = (TMAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *context = [delegate managedObjectContext];
    Source *source = [NSEntityDescription insertNewObjectForEntityForName:@"Source" inManagedObjectContext:context];
    source.url = urlField.text;
    source.name = urlField.text;
    source.enable = @1;
    NSError *error ;
    if (![context save:&error]) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }


    [self fetchDataSource];
    [self.tableView reloadData];
}
-(void) updateAllSource
{

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
