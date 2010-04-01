//
//  WifiViewController.h
//  Geomena iPhone Survey
//
//  Created by Andre Navarro on 3/31/10.
//  Copyright Geomena All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WiFiScanner.h"
#import <CoreLocation/CoreLocation.h>

@interface WifiViewController : TTTableViewController <GeolocationWiFiSpotterDelegate, CLLocationManagerDelegate, TTURLRequestDelegate> {
	CLLocationManager *locationManager;
	CLLocationCoordinate2D currentLocation;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;
@end
