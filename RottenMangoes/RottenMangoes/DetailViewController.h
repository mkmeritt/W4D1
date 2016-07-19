//
//  DetailViewController.h
//  RottenMangoes
//
//  Created by Mark Meritt on 2016-07-18.
//  Copyright © 2016 Apptist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
@interface DetailViewController : UIViewController

@property (strong, nonatomic) Movie *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *ratingsLbl;

@end

