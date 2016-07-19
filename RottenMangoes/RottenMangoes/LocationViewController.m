//
//  LocationViewController.m
//  RottenMangoes
//
//  Created by Mark Meritt on 2016-07-19.
//  Copyright © 2016 Apptist. All rights reserved.
//

#import "LocationViewController.h"
#import "Theatre.h"
@interface LocationViewController ()

@property NSMutableArray *theatres;
@property (assign, nonatomic) BOOL shouldZoomIntoUser;


@end

@implementation LocationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.geocoder = [[CLGeocoder alloc] init];
    self.locationManager.delegate = self;
    self.shouldZoomIntoUser = YES;
    
    self.mapView.delegate = self;
    
    if([CLLocationManager locationServicesEnabled]) {
        
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            
            [self.locationManager requestWhenInUseAuthorization];
            
        }
    }
    
    [self addTheatrePins];
    
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse ) {
        self.mapView.showsUserLocation = YES;
        self.mapView.showsPointsOfInterest = YES;
        
        [self.locationManager startUpdatingLocation];
    }
    
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *location = [locations lastObject];
    
    if (self.shouldZoomIntoUser) {
        self.shouldZoomIntoUser = NO;
    
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.001, 0.001));
    [self.mapView setRegion:region animated:YES];
        
    }
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error == nil && [placemarks count] > 0) {
            self.placemark = [placemarks lastObject];
            self.postalCode = self.placemark.postalCode;
            NSLog(@"%@", self.postalCode);
        }
    }];
    
}

-(void)addTheatrePins{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=V6B1E6&movie=%@", self.movie.title]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Request error %@", error.debugDescription);
        }
        
        else if (!error){
            
            NSError *jsonError;
            
            NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if(!jsonError){
                
                NSMutableArray *theatres = [NSMutableArray array];
                
                for(NSDictionary *theatreDict in resultDict[@"theatres"]){
                    Theatre *theatre = [[Theatre alloc] init];
                    theatre.coordinate = CLLocationCoordinate2DMake([theatreDict[@"lat"] doubleValue], [theatreDict[@"lng"] doubleValue]);
                    theatre.title = theatreDict[@"name"];
                    [theatres addObject:theatre];
                    [self.mapView addAnnotation:theatre];

                }
                
                self.theatres = theatres;
              
            }
            
        }
    }];
    
    [dataTask resume];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Location error: %@", error.localizedDescription);
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if (annotation == mapView.userLocation) {
        return nil;
    }
    
    MKAnnotationView *theatreView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"Theatre"];
    if(!theatreView) {
        theatreView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Theatre"];
        [theatreView setCanShowCallout:YES];
        theatreView.image = [UIImage imageNamed:@"bikeStation"];
        theatreView.centerOffset = CGPointMake(0, theatreView.image.size.height / 2);
    }
    
    return theatreView;
    
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
