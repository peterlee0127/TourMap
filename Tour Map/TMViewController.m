//
//  TMViewController.m
//  Tour Map
//
//  Created by Peterlee on 7/9/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import "TMViewController.h"

@interface TMViewController ()

@end

@implementation TMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Tour Map";
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate = self;
    self.mapView.showsBuildings = YES;
    self.mapView.showsUserLocation = YES;
    self.mapView.showsPointsOfInterest = YES;
    [self.view addSubview:self.mapView];
    
    [self addMapSettingButton];
    
    self.mapView.centerCoordinate = self.locationManager.location.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 1500, 1500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) addMapSettingButton
{
    UIButton *showCurrentLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(4, self.view.frame.size.height-40-5, 40, 40)];
    showCurrentLocationButton.backgroundColor = [UIColor brownColor];
    [showCurrentLocationButton addTarget:self action:@selector(showLocation) forControlEvents:UIControlEventTouchDown];
    [self.mapView addSubview:showCurrentLocationButton];
    
    UIButton *changeMapTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height-40-5, 40, 40)];
    [changeMapTypeButton setTitle:@"Type" forState:UIControlStateNormal];
    changeMapTypeButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
    changeMapTypeButton.backgroundColor = [UIColor grayColor];
    [changeMapTypeButton addTarget:self action:@selector(changeMapType) forControlEvents:UIControlEventTouchDown];
    [self.mapView addSubview:changeMapTypeButton];
    
    UIButton *updateDataButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-40-5, self.view.frame.size.height-40-5, 40, 40)];
    updateDataButton.backgroundColor = [UIColor yellowColor];
    [updateDataButton addTarget:self action:@selector(updateData) forControlEvents:UIControlEventTouchDown];
    [self.mapView addSubview:updateDataButton];
}

#pragma mark - MapView Setting
-(void) changeMapType
{
    if(self.mapView.mapType == MKMapTypeStandard)
        self.mapView.mapType = MKMapTypeHybrid;
    else
        self.mapView.mapType = MKMapTypeStandard;
}
-(void) showLocation
{
    self.mapView.centerCoordinate = self.locationManager.location.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 1500, 1500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
}
-(void) updateData // Will download All enable Data From Source
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Will download All enable Data from Source" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
