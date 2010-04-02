//
//  WifiViewController.m
//  Geomena iPhone Survey
//
//  Created by Andre Navarro on 3/31/10.
//  Copyright Geomena All rights reserved.
//

#import "WifiViewController.h"

@implementation WifiViewController
@synthesize locationManager, currentLocation, counter;

- (id) init {
	self = [super init];
	if (self != nil) {
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
		self.locationManager.delegate = self; 
		
		self.counter = 0;
		self.title = [NSString stringWithFormat:@"Sent: %d", self.counter];
	}
	return self;
}

- (void)locationManager:(CLLocationManager *)manager
		didUpdateToLocation:(CLLocation *)newLocation
					 fromLocation:(CLLocation *)oldLocation
{
	currentLocation = newLocation.coordinate;
	//[self scanNetworks];
}

- (void)locationUpdate:(CLLocation *)location {
	TTAlert(@"locationUpdate");	
}

- (void)locationManager:(CLLocationManager *)manager
			 didFailWithError:(NSError *)error
{
	TTAlert(@"error getting location");
}

- (void)spotterDidScan
{
	
	NSLog(@"SCANNED!");
	
	NSMutableArray *networkItems = [[NSMutableArray alloc] init];
	NSMutableDictionary *networks = [[NSMutableDictionary alloc]
																	 initWithDictionary:[[WiFiScanner sharedInstance] networks] copyItems:YES];
	
	for (NSString *aNetwork in networks)
	{
		NSString *mac = [NSString stringWithFormat:@"0%@",
										 [aNetwork stringByReplacingOccurrencesOfString:@":" withString:@""]];
				
		[networkItems addObject:[TTTableSubtitleItem itemWithText:aNetwork
																										 subtitle:[networks objectForKey:aNetwork]
																													URL:[NSString stringWithFormat:@"http://geomena.org/ap/%@", mac]]];
		[self sendParametersFor:mac andSSID:[networks objectForKey:aNetwork]];

	}
	
	self.dataSource = [TTSectionedDataSource dataSourceWithItems:networkItems sections:nil];

}

- (void)viewDidLoad {
	[super viewDidLoad];
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	[locationManager startUpdatingLocation];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"scan/send"
																																						 style:UIBarButtonItemStyleBordered target:self
																																						action:@selector(scanNetworks)] autorelease];
//	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Push"
//																																						 style:UIBarButtonItemStyleBordered target:self
//																																						action:@selector(pushToGeomena)] autorelease];
	
	[[WiFiScanner sharedInstance] setDelegate: self];

	[self scanNetworks];
}


-(void)scanNetworks
{
		[[WiFiScanner sharedInstance] scan];
	
}

-(void)pushToGeomena {

	NSMutableDictionary *networks = [[NSMutableDictionary alloc]
																	 initWithDictionary:[[WiFiScanner sharedInstance] networks] copyItems:YES];


	for (NSString *aNetwork in networks) {
		NSString *mac = [NSString stringWithFormat:@"0%@",
										 [aNetwork stringByReplacingOccurrencesOfString:@":" withString:@""]];
		
		[self sendParametersFor:mac andSSID:[networks objectForKey:aNetwork]];
		
	}
}

- (void)sendParametersFor:(NSString*)MAC andSSID:(NSString*)SSID {

	if (currentLocation.latitude != 0. && currentLocation.longitude != 0.) {
		NSLog(@"sending lat: %f and lon: %f", currentLocation.latitude, currentLocation.longitude);
		NSLog(@"sending MAC: %@ and SSID: %@", MAC, SSID);
		
		NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
		 [NSString stringWithFormat:@"%f", currentLocation.latitude], @"latitude",
		 [NSString stringWithFormat:@"%f", currentLocation.longitude], @"longitude",
																SSID, @"essid",
		 nil];
		
		
		NSString *url = [NSString stringWithFormat:@"http://geomena.org/ap/%@", MAC];
		
		TTURLRequest *request = [TTURLRequest requestWithURL:url
																								delegate:self];
		
		request.httpMethod = @"POST";
		[request.parameters addEntriesFromDictionary:parameters];
		

		[request sendSynchronously];	
	}
}
			 
- (void)requestDidFinishLoad:(TTURLRequest*)request {
	NSLog(@"finishined sending one");
	counter++;
	self.title = [NSString stringWithFormat:@"Sent: %d", counter];
}

- (void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error {
	NSLog(@"error: %@", error);
	TTAlert(@"error");
}


- (void)dealloc {
	[locationManager release];
	
	[super dealloc];
}


@end

