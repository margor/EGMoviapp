//
//  EGDetailMovieVC.m
//  EGMoviapp
//
//  Created by Esther Gordo Ramos on 08/12/14.
//  Copyright (c) 2014 Gordo. All rights reserved.
//

#import "EGDetailMovieVC.h"
#import "EGColor.h"

@interface EGDetailMovieVC ()

@end

@implementation EGDetailMovieVC

@synthesize dictMovieSelected; //from EGTableMovies
@synthesize imageViewBackground, imageViewArrow, viewDrawer, textViewPlot;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //[self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"left_arrow"]];
    [self.navigationController setTitle:dictMovieSelected[@"title"]];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem.leftBarButtonItem setTintColor:[EGColor NGDarkBlueColor]];
    [self.navigationItem.leftBarButtonItem setBackgroundImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    NSURL *urlImageMovie = [NSURL URLWithString: dictMovieSelected[@"poster"]];
    UIImage *imageMovie = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlImageMovie]];
    [imageViewBackground setContentMode:UIViewContentModeScaleAspectFill];
    imageViewBackground.image = imageMovie;
    
    [viewDrawer setBackgroundColor:[EGColor NGGreenColor]];
    [viewDrawer.layer setOpacity:0.7];
    
    [textViewPlot setBackgroundColor:[UIColor clearColor]];
    [textViewPlot setTextColor:[EGColor NGDarkBlueColor]];
    [textViewPlot setText:dictMovieSelected[@"plot"]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
