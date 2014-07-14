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
    
    self.mapView = [[MKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.mapView.delegate = self;
    self.mapView.showsBuildings = YES;
    self.mapView.showsUserLocation = YES;
    self.mapView.showsPointsOfInterest = YES;
    [self.view addSubview:self.mapView];
    
    [self addMapSettingButton];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void) viewWillAppear:(BOOL)animated
{
    // Set mapView center to Current Location.
    self.mapView.centerCoordinate = self.locationManager.location.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 1500, 1500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
}
-(void) addMapSettingButton
{
    UIButton *changeMapTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(100, self.view.frame.size.height-44-5, 44, 44)];
    [changeMapTypeButton setTitle:@"Type" forState:UIControlStateNormal];
    changeMapTypeButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
    changeMapTypeButton.backgroundColor = [UIColor grayColor];
    [changeMapTypeButton addTarget:self action:@selector(changeMapType) forControlEvents:UIControlEventTouchDown];
    [self.mapView addSubview:changeMapTypeButton];
   
    UIButton *showCurrentLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(5, self.view.frame.size.height-44-5, 44, 44)];
    showCurrentLocationButton.backgroundColor = [UIColor brownColor];
    [showCurrentLocationButton addTarget:self action:@selector(showLocation) forControlEvents:UIControlEventTouchDown];
    [self.mapView addSubview:showCurrentLocationButton];

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
