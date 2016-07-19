//
//  Theatre.h
//  RottenMangoes
//
//  Created by Mark Meritt on 2016-07-19.
//  Copyright © 2016 Apptist. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface Theatre : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString* title;

@end
