//
//  GeolocationWiFiSpotter.h
//  Geomena iPhone Survey
//
//  Created by Andre Navarro on 3/31/10.
//  Copyright Geomena All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <dlfcn.h>

@protocol GeolocationWiFiSpotterDelegate <NSObject>
- (void)spotterDidScan;
@end

@interface WiFiScanner : NSObject {
	void *libHandle;
	int (*open)(void *);
	int (*bind)(void *, NSString *);
	int (*close)(void *);
	int (*assoc)(void *, NSDictionary*, NSString*);
	int (*scan)(void *, NSArray **, void *);
    CFArrayRef networks;
	id<GeolocationWiFiSpotterDelegate> delegate;
}

@property (nonatomic, assign) id<GeolocationWiFiSpotterDelegate>delegate;

+ (WiFiScanner *)sharedInstance;
- (void)scan;
- (NSMutableDictionary *)networks;
- (NSString *)signalData;
- (int)signalDataAPCount;

@end
