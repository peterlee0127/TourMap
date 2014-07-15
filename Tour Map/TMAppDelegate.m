//
//  TMAppDelegate.m
//  Tour Map
//
//  Created by Peterlee on 7/9/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import "TMAppDelegate.h"
#import <CoreData/CoreData.h>
#import "TMViewController.h"
#import <PKRevealController.h>


#import "TMMenuViewController.h"
#import "TMListViewController.h"
#import "TMDataSourceListViewController.h"
#import "TMAboutViewController.h"

@interface TMAppDelegate() <PKRevealing>

@property (nonatomic,strong) PKRevealController *revealController;
@property (nonatomic,strong) TMMenuViewController *menuViewController;

@end

@implementation TMAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.menuViewController = [[TMMenuViewController alloc] initWithNibName:@"TMMenuViewController" bundle:nil];
    TMViewController *mainViewController = [[TMViewController alloc] initWithNibName:@"TMViewController" bundle:nil];
    UINavigationController *nav= [[UINavigationController alloc] initWithRootViewController:mainViewController];
    mainViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
   
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.056 green:0.614 blue:1.000 alpha:0.550]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    self.revealController = [PKRevealController revealControllerWithFrontViewController:nav leftViewController:self.menuViewController];
    self.revealController.delegate = self;
    
    self.window.rootViewController = self.revealController;
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFrontVC:) name:@"changeFrontVC" object:nil];
    
    return YES;
}
-(void) showMenu
{
    [self.revealController showViewController:self.menuViewController];
}
-(void) changeFrontVC:(NSNotification *) noti
{
    NSUInteger index = [[noti object] integerValue];
    switch (index) {
        case 0:
        {
            TMViewController *mainViewController = [[TMViewController alloc] initWithNibName:@"TMViewController" bundle:nil];
            UINavigationController *nav= [[UINavigationController alloc] initWithRootViewController:mainViewController];
            mainViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
            [self.revealController setFrontViewController:nav];
            break;
        }
        case 1:
        {
            TMListViewController *listViewController = [[TMListViewController alloc] initWithNibName:@"TMListViewController" bundle:nil];
            UINavigationController *nav= [[UINavigationController alloc] initWithRootViewController:listViewController];
            listViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
            [self.revealController setFrontViewController:nav];
            break;
        }
        case 2:
        {
            TMDataSourceListViewController *dataSourceListViewController = [[TMDataSourceListViewController alloc] initWithNibName:@"TMDataSourceListViewController" bundle:nil];
            UINavigationController *nav= [[UINavigationController alloc] initWithRootViewController:dataSourceListViewController];
            dataSourceListViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
            [self.revealController setFrontViewController:nav];
            break;
        }
        case 3:
        {
            TMAboutViewController *aboutVC = [[TMAboutViewController alloc] initWithNibName:@"TMAboutViewController" bundle:nil];
            UINavigationController *nav= [[UINavigationController alloc] initWithRootViewController:aboutVC];
            aboutVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
            [self.revealController setFrontViewController:nav];
            break;
        }
        default:
            break;
    }
    [self.revealController showViewController:self.revealController.rightViewController];
}

#pragma mark - Core Data stack

-(NSManagedObjectContext *) managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"TourMap.sqlite"]];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    return _persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
