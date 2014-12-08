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
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInfoMovies:) name:NOTIF_MOVIES_DID_LIST object:nil];

    quantity = floorf( self.view.bounds.size.height / 100);
    offset = quantity;
    
    arrayMutMovies = [[NSMutableArray alloc]init];

    com = [EGComunication sharedInstance];

    if (cacheMovies == nil) {
        [com getMoviesFromOffset:0 withQuantity:quantity];
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"Downloading data ...";
        [HUD show:YES];

    }else{
        arrayMovies = [cacheMovies objectForKey:@"movies"];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.navigationController.navigationBar setBarTintColor:[EGColor NGGreenColor]];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [EGColor NGDarkBlueColor]}];
    [self.navigationController.navigationBar setTranslucent:NO];
    
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
    
    cell.backgroundColor = [EGColor NGDarkBlueColor];
    NSDictionary *dictMovie = [[NSDictionary alloc]initWithDictionary:arrayMutMovies[indexPath.row]];
    
    UILabel *labelTitle = (UILabel*)[cell viewWithTag:20];
    [labelTitle setText: dictMovie[@"title"] ];
    [labelTitle setTextColor: [EGColor NGLightBlueColor]];
    
    UIImageView *imageViewMovie = (UIImageView*)[cell viewWithTag:10];
    NSURL *urlImageMovie = [NSURL URLWithString: dictMovie[@"poster"]];
    [imageViewMovie.layer setCornerRadius:imageViewMovie.frame.size.height/2];
    [imageViewMovie.layer setMasksToBounds:YES];
    UIImage *imageMovie = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlImageMovie]];
    [imageViewMovie setContentMode:UIViewContentModeScaleAspectFill];//scale with biggest length:UIViewContentModeScaleAspectFit
    imageViewMovie.image = imageMovie;
    
    UITextView *textViewPlot = (UITextView*) [cell viewWithTag:30];
    NSString *stringPlot = dictMovie[@"plot"];
    [textViewPlot setText: [NSString stringWithFormat:@"%@ ...",[stringPlot substringToIndex:125]]];
    [textViewPlot setTextColor:[UIColor whiteColor]];
    [textViewPlot setBackgroundColor:[UIColor clearColor]];
    
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
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = self.view.bounds.size.height / quantity;
    return height;
}

# pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == [arrayMutMovies count] - 1) {
        NSLog(@"...start fetching more items.");
        [com getMoviesFromOffset:offset withQuantity:quantity];
        offset = offset+quantity;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self performSegueWithIdentifier:@"toDetail" sender:indexPath];
    
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
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


# pragma mark - notification handler
-(void)handleInfoMovies:(NSNotification *)sender
{
    arrayMovies = [[NSArray alloc]initWithArray: sender.object[@"movies"]];
    [HUD hide:YES];
    
    [arrayMutMovies addObjectsFromArray:arrayMovies];
    [self.tableView reloadData];

    //[cacheMovies setObject:sender.object[@"movies"] forKey:@"movies"];
    

}

@end
