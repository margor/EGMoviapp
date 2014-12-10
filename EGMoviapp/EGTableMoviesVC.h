//
//  EGTableMoviesVC.h
//  EGMoviapp
//
//  Created by Esther Gordo Ramos on 04/12/14.
//  Copyright (c) 2014 Gordo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Reachability.h"


@interface EGTableMoviesVC : UITableViewController<UIAlertViewDelegate>

-(void)handleInfoMovies:(NSNotification *)sender;

-(void)ckeckIfIsDeviceConnected;

@end
