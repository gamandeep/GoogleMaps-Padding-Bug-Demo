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

#import "GoogleMapsDemos/Samples/VisibleRegionViewController.h"

#import <GoogleMaps/GoogleMaps.h>

static CGFloat kOverlayHeight = 140.0f;

@implementation VisibleRegionViewController {
  GMSMapView *_mapView;
  UIView *_overlay;
  UIBarButtonItem *_flyInButton;
  UIView *customMarker;
  NSLayoutConstraint *yCons;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-37.81969
                                                          longitude:144.966085
                                                               zoom:4];
  _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  _mapView.delegate = self;

  // Enable my location button to show more UI components updating.
  _mapView.settings.myLocationButton = YES;
  _mapView.myLocationEnabled = YES;
  _mapView.padding = UIEdgeInsetsMake(0, 0, kOverlayHeight, 0);
  [self.view addSubview:_mapView];
  _mapView.translatesAutoresizingMaskIntoConstraints = NO;
  [_mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
  [_mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
  [_mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
  [_mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
  // Create a button that, when pressed, causes an overlaying view to fly-in/out.
  _flyInButton = [[UIBarButtonItem alloc] initWithTitle:@"Toggle Overlay"
                                                  style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:@selector(didTapFlyIn)];
  self.navigationItem.rightBarButtonItem = _flyInButton;

  CGRect overlayFrame = CGRectMake(0, -kOverlayHeight, 0, kOverlayHeight);
  _overlay = [[UIView alloc] initWithFrame:overlayFrame];
  _overlay.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;

  _overlay.backgroundColor = [UIColor colorWithHue:0.0 saturation:1.0 brightness:1.0 alpha:0.5];
  [self.view addSubview:_overlay];

  customMarker = [[UIView alloc] initWithFrame:CGRectZero];
  [self.view addSubview:customMarker];
  customMarker.backgroundColor = [UIColor redColor];
  customMarker.translatesAutoresizingMaskIntoConstraints = NO;
  [customMarker.widthAnchor constraintEqualToConstant:20].active = YES;
  [customMarker.heightAnchor constraintEqualToConstant:20].active = YES;
  [customMarker.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
  yCons = [customMarker.centerYAnchor constraintEqualToAnchor:self.view.topAnchor];
  yCons.active = YES;

  [self didTapFlyIn];
}

- (void)didTapFlyIn {
  UIEdgeInsets padding = _mapView.padding;

  CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(-37.81969, 144.966085);
  CGSize size = self.view.bounds.size;
  if (padding.bottom == 0.0f) {
    _overlay.frame = CGRectMake(0, size.height - kOverlayHeight, size.width, kOverlayHeight);
    _mapView.padding = UIEdgeInsetsMake(0, 0, kOverlayHeight, 0);
  } else {
    _overlay.frame = CGRectMake(0, _mapView.bounds.size.height, size.width, 0);
    _mapView.padding = UIEdgeInsetsZero;
  }
  CGPoint point = [_mapView.projection pointForCoordinate:coordinates];
  yCons.constant = point.y;
  [self.view layoutIfNeeded];
}

@end
