//
//  EGComunication.h
//  EGMoviapp
//
//  Created by Esther Gordo Ramos on 04/12/14.
//  Copyright (c) 2014 Gordo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EGComunication : NSObject




+(id) sharedInstance;
-(void)getMoviesFromOffset:(int)offset withQuantity:(int)quantity;
@end
