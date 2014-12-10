//
//  EGDetailMovieVC.h
//  EGMoviapp
//
//  Created by Esther Gordo Ramos on 08/12/14.
//  Copyright (c) 2014 Gordo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EGDetailMovieVC : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewArrow;
@property (weak, nonatomic) IBOutlet UITextView *textViewPlot;
@property (weak, nonatomic) IBOutlet UIView *viewDrawer;
@property (weak, nonatomic) IBOutlet UIView *viewDrawerBackground;

@property (nonatomic,strong) NSDictionary *dictMovieSelected;
@end
