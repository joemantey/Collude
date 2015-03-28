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

@interface EventTableViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

- (IBAction)pullToRefresh:(id)sender;

@end

@implementation EventTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

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

    
    
    SignUpViewController *signUpViewController = [[SignUpViewController alloc] init];
    signUpViewController.delegate = self;
    signUpViewController.fields = PFSignUpFieldsDefault | PFSignUpFieldsDismissButton;
    logInViewController.signUpController = signUpViewController;
        
    [self presentViewController:logInViewController animated:YES completion:nil];
        
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    if (username && password && username.length && password.length) {
        return YES;
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO;
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
    NSLog(@"User dismissed the logInViewController");
}


#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) {
            informationComplete = NO;
            break;
        }
    }
    
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
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
    NSLog(@"%lu", (unsigned long)[self.eventsArray count ]);
}

//makes cells taller
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell" forIndexPath:indexPath];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 1)];
    separator.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:separator];
    
    Event *currentEvent = self.eventsArray[indexPath.row];
    
    //get the name
    if (currentEvent.eventName) {
        cell.eventName.text = currentEvent.eventName;
    }
    NSLog(@"Tableview Delegate ran");
    //get the date
    if (currentEvent.timeOfEvent) {
        NSDate *curentEventDate = currentEvent.timeOfEvent;
        NSString *dateString = [NSDateFormatter localizedStringFromDate:curentEventDate
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterShortStyle];
        cell.eventDate.text = [NSString stringWithFormat:@"%@", dateString];
    }
    
    //get the images
    if (currentEvent.imageLabel) {
        cell.eventIcon.image =  [UIImage imageNamed:currentEvent.imageLabel];
    }

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
    }
}




@end
