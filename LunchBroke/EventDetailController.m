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
#import <MapKit/MapKit.h> 
#import <UINavigationBar+Addition.h>
#import "Locations.h"


@interface EventDetailController () <MKMapViewDelegate>;
- (IBAction)dismissTapped:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) NSMutableArray *eventDataArray;
@property (strong, nonatomic) NSString *eventObjectId;

@property (strong, nonatomic) NSString *eventName;
@property (strong, nonatomic) NSString *attendeeCountString;
@property (strong, nonatomic) NSDate *timeOfEvent;
@property (strong, nonatomic) NSArray *attendees;


@end

@implementation EventDetailController

#define METERS_PER_MILE 1609.344

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTextBox];
    NSLog(@"ObjectID: %@", self.selectedObjectID);
    
    self.mapView.delegate = self;
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar hideBottomHairline];
    
    //dummy data
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 39.281516;
    zoomLocation.longitude= -76.580806;
    
    MKPointAnnotation *mapAnnotation = [[MKPointAnnotation alloc]init];
    [mapAnnotation setCoordinate:zoomLocation];
    [mapAnnotation setTitle:@"Joe's"];
    
    [self.mapView addAnnotation:mapAnnotation];
    
    //make annotiation
    //add annotation to map
    //set the center of the map to the annotation
    //se the region of the map
    // set regions via self.mapview.region --> mkmapregion comprised of a span and center coordinate
    
    //my location
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    [_mapView setRegion:viewRegion animated:YES];
    
    [self fetchEventData];
    [self fetchEventAttendees];
    [self.tableView reloadData];
    
    // Do any additional setup after loading the view.
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];

    
    //turn the bar opaque
    [self.navigationController.navigationBar setTranslucent:NO];
    //set the color of the bar
    [self.navigationController.navigationBar setBarTintColor:[UIColor uig_kyotoEndColor]];
    
    //turn the bar opaque
    [self.navigationController.navigationBar setTranslucent:NO];
    
    
    
}



-(void)setupMap{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
//    annotation.coordinate = item.placemark.coordinate;
    
    [self.mapView addAnnotation: annotation];
}

-(void)setUpTextBox{
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:self.event.timeOfEvent
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];

    
    self.textView.text = [NSString stringWithFormat:@" Name:  %@\n Date & Time:  %@\n Location:  %@\n Foursquare Rating:  N/A", self.event.eventName, dateString, self.event.locationName];
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
        self.eventName = eventStuff.eventName;
        self.timeOfEvent = eventStuff.timeOfEvent;
        self.title = [[NSString stringWithFormat:@"%@ Details", self.eventName] capitalizedString];
        NSLog(@"FETCH DATA TITLE: %@ Details", self.eventName);
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

#pragma mark TableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.attendees count];
 
}

/*
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionHeaderName = @"Attendees";
    return sectionHeaderName;
}
*/

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attendeeCell" forIndexPath:indexPath];
    User *user = self.attendees[indexPath.row];
    cell.textLabel.text = user.username;

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 2)];
    
    lineView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:lineView];
    return cell;
}

@end
