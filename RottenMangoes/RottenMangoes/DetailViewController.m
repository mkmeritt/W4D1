//
//  DetailViewController.m
//  RottenMangoes
//
//  Created by Mark Meritt on 2016-07-18.
//  Copyright © 2016 Apptist. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(Movie*)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = self.detailItem.synopsis;
        self.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.detailItem.imageURL]]];
        self.ratingsLbl.text = self.detailItem.rating;
        NSLog(@"%@", self.detailItem.rating);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showLocation"]) {
        
        LocationViewController *controller = segue.destinationViewController;
        
        controller.movie = self.detailItem;
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
