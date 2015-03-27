//
//  AddLocationViewController.m
//  LnchBrkr
//
//  Created by Ian Smith on 3/16/15.
//  Copyright (c) 2015 Ian Smith. All rights reserved.
//

#import "EventDetailController.h"
#import <Parse/Parse.h>
#import <UIColor+uiGradients.h>
#import "EventTableViewCell.h"
#import "EventTableViewController.h"
#import "Event.h"
#import "User.h"

@interface EventDetailController ()
- (IBAction)dismissTapped:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerOutlet;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *eventDataArray;
@property (strong, nonatomic) NSString *eventObjectId;

@property (strong, nonatomic) NSString *eventName;
@property (strong, nonatomic) NSDate *timeOfEvent;
@property (strong, nonatomic) NSArray *attendees;

@end

@implementation EventDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ObjectID: %@", self.selectedObjectID);
    
    // Do any additional setup after loading the view.
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    //turn the bar opaque
    [self.navigationController.navigationBar setTranslucent:NO];
    //set the color of the bar
    [self.navigationController.navigationBar setBarTintColor:[UIColor uig_kyotoEndColor]];
    
    //turn the bar opaque
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self fetchEventData];
    [self fetchEventAttendees];
    [self.tableView reloadData];
}


-(void)setUpGradient{
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.containerView.bounds;
    gradient.startPoint = CGPointZero;
    gradient.endPoint = CGPointMake(0, 1);
    gradient.colors = [NSArray arrayWithObjects: (id)[[UIColor uig_namnStartColor] CGColor], (id)[[UIColor uig_sunriseStartColor]CGColor], nil];
    
    [self.containerView.layer insertSublayer:gradient atIndex:0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) fetchEventData {
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query getObjectInBackgroundWithId:self.selectedObjectID block:^(PFObject *eventData, NSError *error) {
        Event *eventStuff = (Event *)eventData;
        self.eventName = eventStuff.name;
        self.timeOfEvent = eventStuff.date;
        [self.tableView reloadData];
        NSLog(@"Name: %@ Time of Event: %@", self.eventName, self.timeOfEvent);
    }];
}

- (void) fetchEventAttendees {
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query getObjectInBackgroundWithId:self.selectedObjectID block:^(PFObject *eventData, NSError *error) {
        Event *eventStuff = (Event *)eventData;
        
        PFQuery *attendeeQuery = [eventStuff.Attendees query];
        
        [attendeeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.attendees = objects;
            [self.tableView reloadData];
        }];
    }];
}

- (IBAction)dismissTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.attendees count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attendeeCell" forIndexPath:indexPath];
    User *user = self.attendees[indexPath.row];
    cell.textLabel.text = user.email;
    return cell;
}

@end
