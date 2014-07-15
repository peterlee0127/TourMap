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

@interface TMDataSourceListViewController () <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *sourceArray;

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
    self.navigationItem.rightBarButtonItem = updateBarButton;
    
    [self fetchDataSource];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//    [self.tableView registerNib:[UINib nibWithNibName:@"TMDataSourceTableViewCell" bundle:nil] forCellReuseIdentifier:@"DataSourceList"];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5; //seconds
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr];
  
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
    self.sourceArray = [[context executeFetchRequest:request error:&error] mutableCopy];
   
//    [self.sourceArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        Source *source = obj;
//        NSLog(@"%@ %@",source.name,source.enable);
//    }];
}
#pragma mark - UITableView DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TMDataSourceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DataSourceList"];
    if(cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TMDataSourceTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Source *source = self.sourceArray[indexPath.row];
    cell.nameLabel.text = source.name;
    cell.urlLabel.text = source.url;
    cell.enable = [source.enable boolValue];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(![source.enable boolValue])
    {
        cell.enable = NO;
    }
    else
    {
        cell.enable=YES;
    }
    
    if(source.date == [NSDate date])
    {
        cell.statusLabel.text = @"updated";
        cell.statusLabel.textColor = [UIColor greenColor];
    }
    else
    {
        cell.statusLabel.text = @"outdated";
        cell.statusLabel.textColor = [UIColor redColor];
    }
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableㄉView viewForHeaderInSection:(NSInteger)section
{
    FXBlurView *headerView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    headerView.blurEnabled = YES;
    headerView.dynamic = YES;
    headerView.blurRadius =12;
    headerView.tintColor = [UIColor clearColor];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(55 , 10, 200, 40)];
    [addButton setTitle:@"Add more DataSource" forState:UIControlStateNormal];
    addButton.titleLabel.textColor = [UIColor colorWithWhite:0.253 alpha:1.000];
    addButton.backgroundColor = [UIColor clearColor];
    [addButton addTarget:self action:@selector(addSource) forControlEvents:UIControlEventTouchDown];
    [headerView addSubview:addButton];
    
    return headerView;
}
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    if(gestureRecognizer.state ==UIGestureRecognizerStateBegan)
    {
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (indexPath == nil)
        return;
    else
    {
        Source *tempSource = self.sourceArray[indexPath.row];
        UIAlertView *alert =[[UIAlertView alloc] init];
        alert.title = @"Delete this Source ?";
        alert.message = tempSource.url;
        alert.delegate = self;
        [alert addButtonWithTitle:@"Delete"];
        [alert addButtonWithTitle:@"Cancel"];
        [self.tableView reloadData];
        [alert show];
        

    }
    }
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
    {
        [self.tableView reloadData];
        return;
    }
    if([alertView.title isEqualToString:@"Delete this Source ?"])
    {
        TMAppDelegate *delegate = (TMAppDelegate *)[UIApplication sharedApplication].delegate;
        NSManagedObjectContext *context = [delegate managedObjectContext];
        NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"Source"];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"url==%@",alertView.message];
        fetchRequest.predicate=predicate;
        Source *source=[[context executeFetchRequest:fetchRequest error:nil] lastObject];
        if(source==nil)
            return;
        [context deleteObject:source];
        [context save:nil];
        
        [self fetchDataSource];
        [self.tableView reloadData]; // tell table to refresh now
        return;
    }
    TMAppDelegate *delegate = (TMAppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];

    
    UITextField *urlField = [alertView textFieldAtIndex:0];
    [[TMDataManager shareInstance] downloadData:urlField.text];
    

    Source *source = [NSEntityDescription insertNewObjectForEntityForName:@"Source" inManagedObjectContext:context];
    source.url = urlField.text;
    source.name = urlField.text;
    source.enable = @1;
    source.date = [NSDate date];
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
