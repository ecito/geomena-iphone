//
//  GeolocationWiFiSpotter.m
//  Geomena iPhone Survey
//
//  Created by Andre Navarro on 3/31/10.
//  Copyright Geomena All rights reserved.
//

#import "WiFiScanner.h"


@implementation WiFiScanner
@synthesize delegate;
static WiFiScanner *sharedInstance;


+ (WiFiScanner *)sharedInstance {
	if (!sharedInstance) sharedInstance = [[self alloc] init];
	return sharedInstance;
}

- (id)init {
	self = [super init];
	libHandle = dlopen("/System/Library/SystemConfiguration/WiFiManager.bundle/WiFiManager", 1);
	open  = dlsym(libHandle, "Apple80211Open");
	bind  = dlsym(libHandle, "Apple80211BindToInterface");
	close = dlsym(libHandle, "Apple80211Close");
	assoc = dlsym(libHandle, "Apple80211Associate");
	scan  = dlsym(libHandle, "Apple80211Scan");
	
	open(&libHandle);
	bind(libHandle, @"en0");
	return self;
}

- (void)close {
	close(libHandle);
	dlclose(libHandle);
}

- (void)scan {
	[NSThread detachNewThreadSelector:@selector(performScan) toTarget:self withObject:nil];
}

- (void)performScan {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	CFDictionaryRef parameters = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
	scan(libHandle, &networks, parameters);
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(spotterDidScan)])
		[self.delegate spotterDidScan];
	else NSLog(@"SPOTTER TRIED TO UPDATE RELEASED OBJECT!");
	[pool release];
}


- (NSMutableDictionary *)networks {

	NSMutableDictionary *networksDict = [NSMutableDictionary dictionary];

	if (networks != nil)
	{
		for (int i = 0, n = CFArrayGetCount(networks); i < n; i++) {
			CFDictionaryRef network = CFArrayGetValueAtIndex(networks, i);
			[networksDict setValue:[NSString stringWithFormat:@"%@", CFDictionaryGetValue(network, @"SSID_STR")]
											forKey:[NSString stringWithFormat:@"%@", CFDictionaryGetValue(network, @"BSSID")]];
		}
	}
	[networksDict retain];
	return networksDict;
}

- (void)dealloc {
	[self close];
	[delegate release];
	[super dealloc];
}

@end
