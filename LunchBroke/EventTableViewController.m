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
#import <UINavigationBar+Addition.h>

@interface EventTableViewController () 

- (IBAction)pullToRefresh:(id)sender;

@end

@implementation EventTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpNavigationBar];
    [self setUpLoginAndSignUp];
    [self setUpLogo];

    [self fetchEvents];
    [self fetchEventData];
    
    [self reloadDataMethod];
    
    //sets up notification center for fetch events and the command to reload the table method
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchEvents) name:@"fetchEventsNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataMethod) name:@"reloadTable" object:nil];
    
    
}

-(void)setUpLoginAndSignUp{
    
    //If there is no user signed into the app
    if (![PFUser currentUser]) {
        
        //create a login view controller using your subclassed LoginView, set the delegate and present it
        LoginViewController *logInViewController = [[LoginViewController alloc] init];
        logInViewController.delegate = self;
        [self presentViewController:logInViewController animated:YES completion:nil];
        
        //create a sublclassed signupview controller, set the delegate, set the fields to be standard provided by parse, and set it as the signUpController property of signupviewcontroller
        SignUpViewController *signUpViewController = [[SignUpViewController alloc] init];
        signUpViewController.delegate = self;
        signUpViewController.fields = PFSignUpFieldsDefault;
        logInViewController.signUpController = signUpViewController;
    }
}


-(void)setUpNavigationBar{
    
    
    //create navigation bar
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    //set the color of the bar
    [self.navigationController.navigationBar setBarTintColor:[UIColor uig_kyotoEndColor]];
    
    //turn the bar opaque
    [self.navigationController.navigationBar setTranslucent:NO];
    
    //hide the bottom line under the navigation bar
    [navigationBar hideBottomHairline];
    
}

-(void)setUpLogo{
    
    UIButton *logoView = [[UIButton alloc] initWithFrame:CGRectMake(0,0,10,50)];
    [logoView setBackgroundImage:[UIImage imageNamed:@"Raccoon.png"] forState:UIControlStateNormal];
    [logoView setUserInteractionEnabled:NO];
    self.navigationItem.titleView = logoView;
}

-(void)reloadDataMethod{
    [self.tableView reloadData];
}

//Obligatory dealloc for the NSNotificationCenter
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark The delegate for the login and signUp view controllers

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
    [cell updateCount];
    

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 2)];
    
    lineView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:lineView];
    return cell;
}


#pragma mark - Other functionality

- (IBAction)pullToRefresh:(id)sender {
    [self fetchEvents];
    [sender endRefreshing];
}


#pragma mark - Parse methods

//this methods fetches the array of all the events from parse
-(void)fetchEvents{
    PFQuery *eventQuery = [PFQuery queryWithClassName:@"Event"];
    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.eventsArray = [NSMutableArray arrayWithArray:objects];
        [self.tableView reloadData];
    }];
}

//this method
-(void)fetchEventData {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    
    [query getObjectInBackgroundWithId:self.selectedEventObjectID block:^(PFObject *eventData, NSError *error) {
        
        Event *eventWithDetails = (Event *)eventData;
        self.eventName = eventWithDetails.eventName;
        self.timeOfEvent = eventWithDetails.timeOfEvent;
        [self.tableView reloadData];
        
    }];
}


#pragma mark - Data methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"tableViewToDetailSegue"]){
        
        //set a PFObject equal to the selected event...
        PFObject *myObject = [self.eventsArray objectAtIndex:[self.tableView indexPathForSelectedRow].row];
       
        
        //...and get it's object ID
        self.selectedEventObjectID = [myObject objectId];
        
        //Create a nav controller and cast it as a destinationViewController
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        
        //create an instance of the event detail controller and cast is at a topViewController
        EventDetailController *controller = (EventDetailController *)navController.topViewController;
        
        //pass the controller data to the object ID property
        controller.selectedObjectID = [myObject objectId];
        
        //pass along the event to the event property on the destination VC while you are at it
        controller.event = [self.eventsArray objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}





@end
