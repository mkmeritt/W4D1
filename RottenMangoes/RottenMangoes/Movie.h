//
//  Movie.h
//  RottenMangoes
//
//  Created by Mark Meritt on 2016-07-18.
//  Copyright © 2016 Apptist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Movie : NSObject

@property (nonatomic) NSString* synopsis;
@property (nonatomic) NSString* rating;
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* imageURL;

@end
