//
//  EGTableMoviesVC.m
//  EGMoviapp
//
//  Created by Esther Gordo Ramos on 04/12/14.
//  Copyright (c) 2014 Gordo. All rights reserved.
//

#import "EGTableMoviesVC.h"
#import "EGComunication.h"
#import "MBProgressHUD.h"
#import "EGColor.h"
#import "EGDetailMovieVC.h"

#define screen self.view.bounds
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


@interface EGTableMoviesVC ()

@end

@implementation EGTableMoviesVC{
    EGComunication *com;
    NSArray *arrayMovies;
    NSMutableArray *arrayMutMovies;
    MBProgressHUD * HUD;
    NSCache *cacheMovies;
    int quantity;
    int offset;
    UILabel *labelPull;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInfoMovies:) name:@"moviesDidList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInfoMovies:) name:@"moviesDidFailList" object:nil];

    quantity = floorf( self.view.bounds.size.height / 100);
    offset = quantity;
    
    arrayMutMovies = [[NSMutableArray alloc]init];
    com = [EGComunication sharedInstance];

    [self ckeckIfIsDeviceConnected];

/*
    if (cacheMovies == nil) {
        [com getMoviesFromOffset:0 withQuantity:quantity];
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"Downloading data ...";
        [HUD show:YES];

    }else{
        arrayMovies = [cacheMovies objectForKey:@"movies"];
    }*/
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.navigationController.navigationBar setBarTintColor:[EGColor NGGreenColor]];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [EGColor NGDarkBlueColor]}];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationItem setTitle:@"Movies"];
    
    [self.tableView setBackgroundColor:[EGColor NGDarkBlueColor]];

    //Pull to refresh (in a uitableviewcontroller)
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [EGColor NGDateBlueColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(ckeckIfIsDeviceConnected)
                  forControlEvents:UIControlEventValueChanged];
    UIImageView *imageViewIcono = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(screen)-90, 0, 180, 66)];
    imageViewIcono.image = [UIImage imageNamed:@"icon_novagecko.png"];
    [self.refreshControl addSubview:imageViewIcono];
    
    //UIView notifying existence pull to refresh
    labelPull = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(screen), 60)];
    [labelPull setBackgroundColor:[EGColor NGLightBlueColor]];
    [labelPull setText:@"Pull to Refresh"];
    [labelPull setTextAlignment:NSTextAlignmentCenter];
    [labelPull setTextColor:[UIColor whiteColor]];
    [self.view addSubview:labelPull];
    
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:@"Movies"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [arrayMutMovies count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    // tag: 10 - ImageView "poster"
    // tag: 20 - Label "title"
    // tag: 30 - TextView "plot"
    // tag: 40 - Label "releaseDate"
    
    
    cell.backgroundColor = [EGColor NGDarkBlueColor];
    NSDictionary *dictMovie = [[NSDictionary alloc]initWithDictionary:arrayMutMovies[indexPath.row]];
    
    UILabel *labelTitle = (UILabel*)[cell viewWithTag:20];
    [labelTitle setText: dictMovie[@"title"] ];
    [labelTitle setTextColor: [EGColor NGLightBlueColor]];
    [labelTitle setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    if IS_IPAD [labelTitle setFont:[UIFont fontWithName:@"Helvetica" size:23]];
    
    UIImageView *imageViewMovie = (UIImageView*)[cell viewWithTag:10];
    NSURL *urlImageMovie = [NSURL URLWithString: dictMovie[@"poster"]];
    [imageViewMovie.layer setCornerRadius:imageViewMovie.frame.size.height/2];
    [imageViewMovie.layer setMasksToBounds:YES];
    UIImage *imageMovie = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlImageMovie]];
    [imageViewMovie setContentMode:UIViewContentModeScaleAspectFill];
    imageViewMovie.image = imageMovie;
    
    UITextView *textViewPlot = (UITextView*) [cell viewWithTag:30];
    NSString *stringPlot = dictMovie[@"plot"];
    if (![dictMovie[@"plot"]isEqualToString:@"N/A"]){
        [textViewPlot setText: [NSString stringWithFormat:@"%@ ...",[stringPlot substringToIndex:125]]];
    }
    [textViewPlot setTextColor:[UIColor whiteColor]];
    [textViewPlot setBackgroundColor:[UIColor clearColor]];
    [textViewPlot setFont:[UIFont fontWithName:@"Helvetica" size:11]];
    if IS_IPAD [textViewPlot setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        
    
    UILabel *labelDate = (UILabel *) [cell viewWithTag:40];
    [labelDate setTextColor:[EGColor NGDateBlueColor]];
    NSDateFormatter *dateFormatReceived = [[NSDateFormatter alloc]init];
    [dateFormatReceived setDateFormat:@"dd MMM yyyy"];
    NSString *stringDateReceived = dictMovie[@"releaseDate"];
    NSDate *dateReceived = [[NSDate alloc]init];
    dateReceived = [dateFormatReceived dateFromString:stringDateReceived];
    
    NSDateFormatter *dateFormatDisplay = [[NSDateFormatter alloc]init];
    [dateFormatDisplay setDateFormat:@"EE, dd MMM yyyy"];
    NSString *stringDateDisplay = [dateFormatDisplay stringFromDate:dateReceived];
    labelDate.text = stringDateDisplay;
    [labelDate setFont:[UIFont fontWithName:@"Helvetica" size:10]];
    if IS_IPAD [labelTitle setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

# pragma mark TableView Delegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == [arrayMutMovies count] - 1) {
        [com getMoviesFromOffset:offset withQuantity:quantity];
        offset = offset+quantity;
        
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *movieSelected = [[NSDictionary alloc]initWithDictionary:arrayMutMovies[indexPath.row]];
        EGDetailMovieVC *destinationVC = (EGDetailMovieVC*)[segue destinationViewController];
        destinationVC.dictMovieSelected = movieSelected;
        
    }
}



# pragma mark - notification handler
-(void)handleInfoMovies:(NSNotification *)sender
{
    if ([sender.name isEqualToString:@"moviesDidList"]) {
        arrayMovies = [[NSArray alloc]initWithArray: sender.object[@"movies"]];
        [HUD hide:YES];
        labelPull.hidden = YES;
        [arrayMutMovies addObjectsFromArray:arrayMovies];
        [self.tableView reloadData];
        if (self.refreshControl) {
            [self.refreshControl endRefreshing];
        }
    }
    else if ([sender.name isEqualToString:@"moviesDidFailList"]){
        [HUD hide:YES];
        if (self.refreshControl) {
            [self.refreshControl endRefreshing];
        }
        labelPull.hidden = NO;
        if ([sender.object isKindOfClass:[NSError class]]) {
            NSError *e = sender.object;
            if(e.code == -1009){
                
                [[[UIAlertView alloc] initWithTitle:@"Warning"
                                            message:@"There was a problem downloading data."
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            }
        }
    }
    
    /*
    //[cacheMovies setObject:sender.object[@"movies"] forKey:@"movies"]; //create singleton. ContextStorage
    ///////
    NSDictionary *dictMovies = [[NSDictionary alloc]init];
    dictMovies = sender.object[@"movies"];

    // Imagen
    //NSString *imagename = imageFile.name;
    UIImage *image = [[[EGContextStorage sharedInstance] imagesCached] objectForKey:imagename]; //nscache
    if (image) {
        //NSLog(@"image cached");//: %@",imagePath);
        imagenServicio.image=image;
    } else {
        // Is in the app's Documents directory ?
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imagename]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
            image = [UIImage imageWithContentsOfFile:imagePath];
            imagenServicio.image=image;
            //NSLog(@"image already saved in document directory");//: %@",imagePath);
            // NSCache image
            [[[EGContextStorage sharedInstance] imagesCached] setObject:image forKey:imagename];
        } else {
            imagenServicio.image = [UIImage new];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageFile.url]];
                UIImage *image = [UIImage imageWithData:imageData];
                if (image) {
                    dispatch_sync(dispatch_get_main_queue(), ^(void) {
                        imagenServicio.image = image;
                    });
                    // NSCache image
                    [[[EGContextStorage sharedInstance] imagesCached] setObject:image forKey:imagename];
                    // And save in the app's Documents directory
                    NSData *imagePNGData = UIImagePNGRepresentation(image);
                    //NSLog(@"pre writing to file: %@",imagename);
                    if (![imagePNGData writeToFile:imagePath atomically:NO]) {
                        //NSLog(@"Failed to cache image data to disk");
                    } else {
                        //NSLog(@"the cachedImagedPath is %@",imagePath);
                    }
                }
            });
        }
    }
    ///////
    */
    
    
}

#pragma mark - personal methods
- (void) ckeckIfIsDeviceConnected{
    int status = 0;
    // 0 - No connection
    // 1 - Connected
    
    NetworkStatus reachabilityStatus;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    reachabilityStatus = [reachability currentReachabilityStatus];
    if(reachabilityStatus == NotReachable) {
        //No internet
        status = 0;
    } else {
        //Connected
        status = 1;
    }
    

    if (status == 0) {//No internet
        [[[UIAlertView alloc] initWithTitle:@"Warning"
                                    message:@"Your device is not connected to internet.\n Pull to try it again."
                                   delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:nil] show];
        labelPull.hidden = NO;
        [HUD hide:YES];
        if (self.refreshControl) {
            [self.refreshControl endRefreshing];
        }
    }
    else { //connected
        [com getMoviesFromOffset:0 withQuantity:quantity];
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"Downloading data ...";
        [HUD show:YES];
    }
    
}



@end
