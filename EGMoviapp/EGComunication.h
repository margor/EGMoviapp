//
//  EGComunication.h
//  EGMoviapp
//
//  Created by Esther Gordo Ramos on 04/12/14.
//  Copyright (c) 2014 Gordo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EGComunication : NSObject


#define NOTIF_MOVIES_DID_LIST @"moviesDidList"
#define NOTIF_MOVIES_DID_FAIL_LIST @"moviesDidFailList"


+(id) sharedInstance;
-(void)getPelisFromOffset:(int)offset withQuantity:(int)quantity;
@end
