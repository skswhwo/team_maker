//
//  ReceiveTeamViewController.m
//  Team
//
//  Created by ChoJaehyun on 2015. 11. 11..
//  Copyright © 2015년 Classting. All rights reserved.
//

#import "ReceiveTeamViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ReceiveTeamViewController ()
<CLLocationManagerDelegate>
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *UUID;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation ReceiveTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"here");
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    [self.locationManager requestWhenInUseAuthorization];

    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"0C4BADFF-498E-4C83-B65D-7E86FD068A18"];
    _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.MobileTuts.iBeacons"];
    [_locationManager startMonitoringForRegion:_beaconRegion];
    [self.locationManager startUpdatingLocation];
    [self locationManager:_locationManager didStartMonitoringForRegion:_beaconRegion];
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Beacon Found");
    [_locationManager startRangingBeaconsInRegion:_beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Left Region");
    [_locationManager stopRangingBeaconsInRegion:_beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon = [beacons lastObject];
    
    NSLog(@"what? %@",beacon.proximityUUID.UUIDString);
    if (beacon.proximity == CLProximityUnknown) {
        _distanceLabel.text = @"Unknown Proximity";
//        [_view setBackgroundColor:[UIColor blackColor]];
    } else if (beacon.proximity == CLProximityImmediate) {
        _distanceLabel.text = @"Immediate";
//        [_view setBackgroundColor:[UIColor redColor]];
    } else if (beacon.proximity == CLProximityNear) {
        _distanceLabel.text = @"Near";
//        [_view setBackgroundColor:[UIColor orangeColor]];
    } else if (beacon.proximity == CLProximityFar) {
        _distanceLabel.text = @"Far";
//        [_view setBackgroundColor:[UIColor blueColor]];
    }
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"???");
    [_locationManager startRangingBeaconsInRegion:_beaconRegion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
