//
//  TMDataSourceListViewController.m
//  Tour Map
//
//  Created by Peterlee on 7/11/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import "TMDataSourceListViewController.h"
#import "TMSuggestionSourceViewController.h"
#import "TMDataSourceTableViewCell.h"
#import <FXBlurView.h>
#import "TMAppDelegate.h"
#import <CoreData/CoreData.h>
#import "Source.h"
#import "Place.h"
#import "TMDataManager.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>

@interface TMDataSourceListViewController () <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSFetchedResultsController *fetchResultsController;

@end


@implementation TMDataSourceListViewController
@synthesize fetchResultsController = _fetchResultsController;

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
    UIBarButtonItem *updateBarButton  =[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Update", nil) style:UIBarButtonItemStylePlain target:self action:@selector(updateAllSource)];
    self.navigationItem.rightBarButtonItem = updateBarButton;
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    [self.tableView registerNib:[UINib nibWithNibName:@"TMDataSourceTableViewCell" bundle:nil] forCellReuseIdentifier:@"DataSourceList"];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5; //seconds
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr];

 
    // Do any additional setup after loading the view from its nib.
}
-(void) viewWillAppear:(BOOL)animated
{
   [self addFooterView];
}
- (NSFetchedResultsController *)fetchedResultsController {
   
    TMAppDelegate *delegate = (TMAppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    if (_fetchResultsController != nil) {
        return _fetchResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Source" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"url" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:context sectionNameKeyPath:nil
                                                   cacheName:@"SourceCache"];
    self.fetchResultsController = theFetchedResultsController;
    _fetchResultsController.delegate = self;
    
    return _fetchResultsController;
    
}

- (void)configureCell:(TMDataSourceTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  
    Source *source  = [self.fetchResultsController objectAtIndexPath:indexPath];
    cell.nameLabel.text = source.name;
    cell.urlLabel.text = source.url;
    cell.enable = [source.enable boolValue];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(!cell.enable)
        cell.enable = NO;
    else
        cell.enable=YES;
    [cell layoutSubviews];
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
}

#pragma mark - UITableView DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TMDataSourceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DataSourceList"];
    [self configureCell:cell atIndexPath:indexPath];
    
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
    [addButton setTitle:NSLocalizedString(@"Add Source", nil) forState:UIControlStateNormal];
    addButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    addButton.titleLabel.textColor = [UIColor colorWithWhite:0.557 alpha:1.000];
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
            Source *tempSource = [self.fetchResultsController objectAtIndexPath:indexPath];
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
    id  sectionInfo =
    [[self.fetchResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
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
   Source *temp= [self.fetchResultsController objectAtIndexPath:indexPath];
    [temp setValue:@(![temp.enable boolValue]) forKey:@"enable"];
    [self.fetchResultsController.managedObjectContext save:nil];
    
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
-(void) addSuggestionPlace
{
    TMSuggestionSourceViewController *suggectionSourceVC = [[TMSuggestionSourceViewController alloc] initWithNibName:@"TMSuggestionSourceViewController" bundle:nil];
    [self.navigationController pushViewController:suggectionSourceVC animated:YES];
    
    [self.tableView reloadData];
    
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
        NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"Source"];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"url==%@",alertView.message];
        fetchRequest.predicate=predicate;
        Source *source=[[self.fetchResultsController.managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
        if(source==nil)
            return;
        [self.fetchResultsController.managedObjectContext deleteObject:source];
        [self.fetchResultsController.managedObjectContext save:nil];
        
        [self.tableView reloadData];

        
        return;
    }
    
    UITextField *urlField = [alertView textFieldAtIndex:0];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    AFHTTPRequestOperationManager *manager =[[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:urlField.text parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSLog(@"Source has content");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // time-consuming task
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        });
        
        NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"Source"];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"url==%@",urlField.text];
        fetchRequest.predicate=predicate;
        Source *temp=[[self.fetchResultsController.managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
        if(temp)
        {
            NSLog(@"exist");
            return;
        }
      
        
        TMAppDelegate *delegate = (TMAppDelegate *)[UIApplication sharedApplication].delegate;
        NSManagedObjectContext *context = [delegate managedObjectContext];
        
        Source *source = [NSEntityDescription insertNewObjectForEntityForName:@"Source" inManagedObjectContext:context];
        source.url = urlField.text;
        source.name = urlField.text;
        source.enable = @1;
        source.date = [NSDate date];
//        source.place = [self convertToPlaceModel:responseObject];
        NSError *error ;
        if (![context save:&error]) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        
        
        [self.tableView reloadData];
         
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fetch Source Fail" message:@"Please check your source url." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
       
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // time-consuming task
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        });
        [self.tableView reloadData];
    }];
    
  
}
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(TMDataSourceTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}
-(NSData *) convertToPlaceModel:(NSArray *) array
{
    NSMutableArray *mutableArr = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict = (NSDictionary *)obj;
        Place *tempPlace = [[Place alloc] init];
        tempPlace.type = dict[@"type"];
        tempPlace.name = dict[@"title"];
        tempPlace.latitude = [NSNumber numberWithFloat:[dict[@"latitude"] floatValue]];
        tempPlace.longitude = [NSNumber numberWithFloat:[dict[@"longitude"] floatValue]];
        tempPlace.date = dict[@"date"];
        tempPlace.detail = dict[@"placeDetail"];
        [mutableArr addObject:tempPlace];
    }];
     return [NSKeyedArchiver archivedDataWithRootObject:mutableArr];
}
-(void) updateAllSource;
{

}
-(void) addFooterView;
{
    FXBlurView *footerView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-60, 320, 60)];
    footerView.blurEnabled = YES;
    footerView.blurRadius = 12;
    footerView.tintColor = [UIColor clearColor];
    footerView.backgroundColor = [UIColor clearColor];
    
    UIButton *addSuggectionButton = [[UIButton alloc] initWithFrame:CGRectMake(55 ,15 , 200, 30)];
    addSuggectionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [addSuggectionButton setTitle:NSLocalizedString(@"Add Template Source", nil) forState:UIControlStateNormal];
    addSuggectionButton.titleLabel.textColor = [UIColor colorWithWhite:0.557 alpha:1.000];
    addSuggectionButton.backgroundColor = [UIColor clearColor];
    [addSuggectionButton addTarget:self action:@selector(addSuggestionPlace) forControlEvents:UIControlEventTouchDown];
    [footerView addSubview:addSuggectionButton];

    [self.view addSubview:footerView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
