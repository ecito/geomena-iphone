//
//  AppDelegate.m
//  Geomena iPhone Survey
//
//  Created by Andre Navarro on 3/31/10.
//  Copyright Geomena All rights reserved.
//

#import "AppDelegate.h"
#import "WifiViewController.h"

@implementation AppDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationDidFinishLaunching:(UIApplication *)application {
  TTNavigator* navigator = [TTNavigator navigator];
  navigator.persistenceMode = TTNavigatorPersistenceModeAll;

  TTURLMap* map = navigator.URLMap;

  [map from:@"*" toViewController:[TTWebController class]];
	[map from:@"geo://wifi" toViewController:[WifiViewController class]];
	
	[navigator openURL:@"geo://wifi" animated:NO];
}


@end
