//
//  LocationViewController.h
//  RottenMangoes
//
//  Created by Mark Meritt on 2016-07-19.
//  Copyright © 2016 Apptist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
@import MapKit;
@import CoreLocation;

@interface LocationViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) Movie* movie;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLPlacemark *placemark;
@property (strong, nonatomic) NSString *postalCode;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
