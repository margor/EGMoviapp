//
//  EGComunication.m
//  EGMoviapp
//
//  Created by Esther Gordo Ramos on 04/12/14.
//  Copyright (c) 2014 Gordo. All rights reserved.
//

#import "EGComunication.h"
#import "SBJson.h"
#import "AFNetworking.h"
#import "AFHTTPClient.h"
#import "MBProgressHUD.h"

@implementation EGComunication

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (id)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


-(void)getMoviesFromOffset:(int)offset withQuantity:(int)quantity
{

    
    NSString *token = @"ielpsk73";
    
    NSString *urlString = [NSString stringWithFormat:@"http://moviapp.novagecko.com/get_movies?APIKey=%@&offset=%i&quantity=%i",token, offset, quantity];
    
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:urlString
                                                      parameters:nil];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation =[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //NSLog(@"%@",JSON);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"moviesDidList" object:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //NSLog(@"Info received: %@",error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"moviesDidFailList" object:error];
        
    }];
    
    [operation start];
    

}
@end
