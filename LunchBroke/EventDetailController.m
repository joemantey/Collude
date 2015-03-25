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

@interface EventDetailController ()
- (IBAction)dismissTapped:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerOutlet;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *eventDataArray;
@property (strong, nonatomic) NSString *eventObjectId;

@end

@implementation EventDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ObjectID: %@", self.selectedObjectID);

    // Do any additional setup after loading the view.
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    //set the color of the bar
    [self.navigationController.navigationBar setBarTintColor:[UIColor uig_namnStartColor]];
    
    //turn the bar opaque
    [self.navigationController.navigationBar setTranslucent:NO];
    //set the color of the bar
    [self.navigationController.navigationBar setBarTintColor:[UIColor uig_namnStartColor]];
    
    //turn the bar opaque
    [self.navigationController.navigationBar setTranslucent:NO];
    
//    [self fetchEventData];
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

-(void) fetchEventData
{
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    //[query whereKey:@"objectId" equalTo:selectedObjectID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (IBAction)dismissTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attendeeCell" forIndexPath:indexPath];
    cell.textLabel.text = @"Names of attendees";
    return cell;
}

@end
