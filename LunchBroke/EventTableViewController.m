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
#import "SignUpViewController.h"
#import "EventDetailController.h"
#import "Event.h"
#import "EventIconCollectionViewCell.h"
#import "EventIcon.h"

@interface EventTableViewController () 

- (IBAction)pullToRefresh:(id)sender;

@end

@implementation EventTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setColors];
    [self fetchEvents]; 
    [self fetchEventData];
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchEvents) name:@"fetchEventsNotification" object:nil];
    
    
 
    if (![PFUser currentUser]) { // No user logged in
        
    LoginViewController *logInViewController = [[LoginViewController alloc] init];
    logInViewController.delegate = self;
    [self presentViewController:logInViewController animated:YES completion:nil];
    
    SignUpViewController *signUpViewController = [[SignUpViewController alloc] init];
    signUpViewController.delegate = self;
    signUpViewController.fields = PFSignUpFieldsDefault;
    logInViewController.signUpController = signUpViewController;
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

-(void)setColors {
    //set the color of the bar
    [self.navigationController.navigationBar setBarTintColor:[UIColor uig_kyotoEndColor]];
    
    //turn the bar opaque
    [self.navigationController.navigationBar setTranslucent:NO];
}

-(void) fetchEvents {
    PFQuery *eventQuery = [PFQuery queryWithClassName:@"Event"];
    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.eventsArray = [NSMutableArray arrayWithArray:objects];
        [self.tableView reloadData];
    }];
}

-(void) fetchEventData {
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query getObjectInBackgroundWithId:self.selectedObjectID block:^(PFObject *eventData, NSError *error) {
        Event *eventStuff = (Event *)eventData;
        self.eventName = eventStuff.eventName;
        self.timeOfEvent = eventStuff.timeOfEvent;
        [self.tableView reloadData];
        NSLog(@"Name: %@ Time of Event: %@", self.eventName, self.timeOfEvent);
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
    
    Event *currentEvent = self.eventsArray[indexPath.row];
    
    cell.event = currentEvent;
    
    [cell updateUI];
    

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 2)];
    
    lineView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:lineView];
    return cell;
}

- (IBAction)pullToRefresh:(id)sender {
    [self fetchEvents];
    [sender endRefreshing];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"tableViewToDetailSegue"]){
        PFObject *myObject = [self.eventsArray objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        self.selectedObjectID = [myObject objectId];
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        EventDetailController *controller = (EventDetailController *)navController.topViewController;
        controller.selectedObjectID = [myObject objectId];
        controller.event = [self.eventsArray objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}





@end
