//
//  MasterViewController.m
//  RottenMangoes
//
//  Created by Mark Meritt on 2016-07-18.
//  Copyright © 2016 Apptist. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Movie.h"
#import "MovieCell.h"

@interface MasterViewController ()

@property NSMutableArray *movies;

@end

@implementation MasterViewController

NSString* reuseIdentifier = @"MovieCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=j9fhnct2tp8wu2q9h75kanh9&page_limit=50"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"Done request");
        
        if(error){
            NSLog(@"Request error %@", error.debugDescription);
        }
        
        else if (!error){
            
            NSError *jsonError;
            
            NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if(!jsonError){
                
                NSLog(@"JSON: %@", resultDict);
                
                NSMutableArray *movies = [NSMutableArray array];
                
                for(NSDictionary *movieDict in resultDict[@"movies"]){
                    Movie *movie = [[Movie alloc] init];
                    movie.synopsis = movieDict[@"synopsis"];
                    movie.imageURL = movieDict[@"posters"][@"thumbnail"];
                    movie.rating = movieDict[@"ratings"][@"critics_rating"];
                    [movies addObject:movie];
                }
                
                self.movies = movies;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
                
            }
            
        }
    }];
    
    [dataTask resume];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        DetailViewController *controller = segue.destinationViewController;
        
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
        Movie *object = [self.movies objectAtIndex:indexPath.row];
        [controller setDetailItem:object];

    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.movies.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Movie *movie = [self.movies objectAtIndex:indexPath.row];
    
    UIImage *movieImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:movie.imageURL]]];
    cell.image.image = movieImg;

    
    return cell;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

@end
