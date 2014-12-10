//
//  EGDetailMovieVC.m
//  EGMoviapp
//
//  Created by Esther Gordo Ramos on 08/12/14.
//  Copyright (c) 2014 Gordo. All rights reserved.
//

#import "EGDetailMovieVC.h"
#import "EGColor.h"

#define screen self.view.bounds
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface EGDetailMovieVC ()

@end

@implementation EGDetailMovieVC{
    UITapGestureRecognizer *tapRecognizer;
    bool isOpened;
    CGRect rectDrawerOpened;
    CGRect rectDrawerClosed;
    CGPoint pointOpened;
    CGPoint pointClosed;
}

@synthesize dictMovieSelected; //from EGTableMovies
@synthesize imageViewBackground, imageViewArrow, viewDrawer, textViewPlot, viewDrawerBackground;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isOpened = NO;

    [self.view setBackgroundColor:[EGColor NGDarkBlueColor]];
    
    textViewPlot.font= [UIFont fontWithName:@"Helvetica" size:13];
    if IS_IPAD textViewPlot.font= [UIFont fontWithName:@"Helvetica" size:20];
    
    pointClosed = CGPointMake(CGRectGetMidX(screen), CGRectGetHeight(screen)+40);
    pointOpened = CGPointMake(CGRectGetMidX(screen), CGRectGetHeight(screen)*2/3);
    if (IS_IPAD) {
        pointOpened = CGPointMake(CGRectGetMidX(screen), CGRectGetHeight(screen)*5/6);

    }

   
    [self.navigationController.navigationBar setTintColor:[EGColor whiteColor]];
    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"left_arrow"];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"left_arrow"];
    [self.navigationController.navigationBar.topItem setTitle:@""];
    [self.navigationItem setTitle:dictMovieSelected[@"title"]];
    
    NSURL *urlImageMovie = [NSURL URLWithString: dictMovieSelected[@"poster"]];
    UIImage *imageMovie = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlImageMovie]];
    [imageViewBackground setContentMode:UIViewContentModeScaleAspectFill];
    imageViewBackground.image = imageMovie;
    
    [viewDrawerBackground setBackgroundColor:[EGColor NGGreenColor]];
    [viewDrawerBackground.layer setOpacity:0.7];
    
    [textViewPlot setBackgroundColor:[UIColor clearColor]];
    [textViewPlot setTextColor:[EGColor NGDarkBlueColor]];
    [textViewPlot setText:dictMovieSelected[@"plot"]];
    
    tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [viewDrawer addGestureRecognizer:tapRecognizer];
    
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

#pragma mark - handle Gesture
-(void)handleTap: (UITapGestureRecognizer*)recognizer
{
    if (!isOpened) {

        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:0 animations:^{
            
            imageViewArrow.transform = CGAffineTransformRotate(imageViewArrow.transform,M_PI);
            [viewDrawer.layer setPosition:pointOpened];
            
        } completion:^(BOOL finished) {}];
        
    }
    else{
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:0 animations:^{
            
            imageViewArrow.transform = CGAffineTransformRotate(imageViewArrow.transform,M_PI);
            [viewDrawer.layer setPosition:pointClosed];

        } completion:^(BOOL finished) {}];    }
    isOpened = !isOpened;

}
@end
