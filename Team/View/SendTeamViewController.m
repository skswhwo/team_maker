//
//  SendTeamViewController.m
//  Team
//
//  Created by ChoJaehyun on 2015. 11. 11..
//  Copyright © 2015년 Classting. All rights reserved.
//

#import "SendTeamViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface SendTeamViewController ()
<CBPeripheralManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) NSDictionary *beaconPeripheralData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;

@end

@implementation SendTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"A2610E08-3095-4857-92F6-AFAABAC3C191"];
    _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:1 minor:1 identifier:@"com.MobileTuts.iBeacons"];
    NSLog(@"my uuid = %@",_beaconRegion.proximityUUID.UUIDString);
    // Do any additional setup after loading the view.
    
    _beaconPeripheralData = [_beaconRegion peripheralDataWithMeasuredPower:nil];
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    
}


#pragma mark - Delegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"update!! %@",@(peripheral.state));
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"On");
        [_peripheralManager startAdvertising:_beaconPeripheralData];
    } else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        NSLog(@"Off");
        [_peripheralManager stopAdvertising];
    } else {
        [UIAlertView showWithTitle:@"" message:@"Unsupported" cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {}];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
