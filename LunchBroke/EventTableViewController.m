//
//  LocationsTableViewController.m
//  LnchBrkr
//
//  Created by Ian Smith on 3/16/15.
//  Copyright (c) 2015 Ian Smith. All rights reserved.
//

#import "EventTableViewController.h"
#import <Parse/Parse.h>
#import "Locations.h"
#import <UIColor+uiGradients.h>
#import "EventTableViewCell.h"
#import "LoginViewController.h"
#import "signUpViewController.h"

@interface EventTableViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

- (IBAction)pullToRefresh:(id)sender;

@end

@implementation EventTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setColors];
    [self fetchEvents];
    [self.tableView reloadData];
    
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    logInViewController.delegate = self;
    [self presentViewController:logInViewController animated:YES completion:nil];
    
    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
    signUpViewController.delegate = self;
    [self presentViewController:signUpViewController animated:YES completion:nil];
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

-(void)setColors
{
    //set the color of the bar
    [self.navigationController.navigationBar setBarTintColor:[UIColor uig_namnStartColor]];
    
    //turn the bar opaque
    [self.navigationController.navigationBar setTranslucent:NO];

    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.tableView.bounds;
    gradient.startPoint = CGPointZero;
    gradient.endPoint = CGPointMake(0, 1);
    gradient.colors = [NSArray arrayWithObjects: (id)[[UIColor whiteColor] CGColor], (id)[[UIColor whiteColor]CGColor], nil];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self fetchEvents];
}

-(void) fetchEvents
{
    PFQuery *eventQuery = [PFQuery queryWithClassName:@"Event"];
    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.eventsArray = [NSMutableArray arrayWithArray:objects];
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.eventsArray count];
}

//makes cells taller
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell" forIndexPath:indexPath];
   
    Event *event = self.eventsArray[indexPath.row];
    cell.event = event;
    
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

- (IBAction)pullToRefresh:(id)sender {
    [self fetchEvents];
    [sender endRefreshing];
}


@end
