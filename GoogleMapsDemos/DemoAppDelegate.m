/*
 * Copyright 2016 Google Inc. All rights reserved.
 *
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
 * file except in compliance with the License. You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "GoogleMapsDemos/DemoAppDelegate.h"

#import <GoogleMaps/GoogleMaps.h>
#import "Samples/VisibleRegionViewController.h"
#import "GoogleMapsDemos/SDKDemoAPIKey.h"

@implementation DemoAppDelegate {
  id _services;
}

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSLog(@"Build version: %d", __apple_build_version__);

  if (kAPIKey.length == 0) {
    // Blow up if APIKey has not yet been set.
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSString *format = @"Configure APIKey inside SDKDemoAPIKey.h for your "
                       @"bundle `%@`, see README.GoogleMapsDemos for more information";
    @throw [NSException exceptionWithName:@"DemoAppDelegate"
                                   reason:[NSString stringWithFormat:format, bundleId]
                                 userInfo:nil];
  }
  [GMSServices provideAPIKey:kAPIKey];
  _services = [GMSServices sharedServices];

  // Log the required open source licenses! Yes, just NSLog-ing them is not enough but is good for
  // a demo.
  NSLog(@"Open source licenses:\n%@", [GMSServices openSourceLicenseInfo]);

  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  VisibleRegionViewController *master = [[VisibleRegionViewController alloc] init];
  self.navigationController =
  [[UINavigationController alloc] initWithRootViewController:master];
  self.navigationController.navigationBar.translucent = NO;
  self.window.rootViewController = self.navigationController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)setSample:(UIViewController *)sample {
  NSAssert([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad,
           @"Expected device to be iPad inside setSample:");

  // Finds the UINavigationController in the right side of the sample, and
  // replace its displayed controller with the new sample.
  UINavigationController *nav =
      [self.splitViewController.viewControllers objectAtIndex:1];
  [nav setViewControllers:[NSArray arrayWithObject:sample] animated:NO];
}

- (UIViewController *)sample {
  NSAssert([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad,
           @"Expected device to be iPad inside sample");

  // The current sample is the top-most VC in the right-hand pane of the
  // splitViewController.
  UINavigationController *nav =
      [self.splitViewController.viewControllers objectAtIndex:1];
  return [[nav viewControllers] objectAtIndex:0];
}

@end
