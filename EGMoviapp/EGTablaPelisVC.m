//
//  EGTablaPelisVC.m
//  EGMoviapp
//
//  Created by Esther Gordo Ramos on 04/12/14.
//  Copyright (c) 2014 Gordo. All rights reserved.
//

#import "EGTablaPelisVC.h"
#import "EGComunication.h"
#import "MBProgressHUD.h"
#import "EGColor.h"

@interface EGTablaPelisVC ()

@end

@implementation EGTablaPelisVC{
    EGComunication *com;
    NSArray *arrayMovies;
    MBProgressHUD * HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    com = [EGComunication sharedInstance];

    [com getPelisFromOffset:0 withQuantity:10];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"Downloading data ...";
    [HUD show:YES];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInfoMovies:) name:NOTIF_MOVIES_DID_LIST object:nil];
    
    [self.navigationController.navigationBar setBarTintColor:[EGColor NGGreenColor]];
    //[self.navigationController.navigationBar setTranslucent:NO];
    //[self.navigationController.navigationBar setTitleTextAttributes:@[NSForegroundColorAttributeName:[EGColor NGDarkBlueColor]]];
    
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
    return 241;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *dictMovie = [[NSDictionary alloc]initWithDictionary:arrayMovies[indexPath.row]];
    
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
    [textViewPlot setText: dictMovie[@"plot"]];
    [textViewPlot setTextColor:[UIColor whiteColor]];
    [textViewPlot setBackgroundColor:[UIColor clearColor]];
    
    UILabel *labelDate = (UILabel *) [cell viewWithTag:40];
    [labelDate setTextColor:[EGColor NGDateBlueColor]];
    //NSDate *dateReceived =
    
    return cell;
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
    NSLog(@"%@",arrayMovies[0]);
    [self.tableView reloadData];
    [HUD hide:YES];

}
@end
