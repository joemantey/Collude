//
//  fourSquareViewControllerTableViewController.m
//  LunchBroke
//
//  Created by Ian Smith on 3/30/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import "fourSquareViewControllerTableViewController.h"
#import "fourSquare.h"
#import "NewEventTableViewController.h"
#import "fourSquareVenue.h"
#import <CoreLocation/CoreLocation.h>
#import <AFNetworking/AFNetworking.h>

@interface fourSquareViewControllerTableViewController ()
- (IBAction)cancelTapped:(id)sender;

@property (strong, nonatomic) NSArray *fourSquareResults;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lng;

@end

@implementation fourSquareViewControllerTableViewController


- (void)viewDidLoad {
	[super viewDidLoad];

	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"fourSquareCell"];


	_locationManager = [[CLLocationManager alloc]init];
	[self.locationManager requestWhenInUseAuthorization];
	[self.locationManager startUpdatingLocation];
}

-(void) setFourSqQuery:(NSString *)fourSqQuery {
    fourSquare *fourSquareStuff = [[fourSquare alloc] init];
    
    [fourSquareStuff getNearby4SquareLocationsWithQuery:fourSqQuery completionBlock:^(id results) {
        self.fourSquareResults = [NSArray arrayWithArray:results[@"response"][@"groups"][0][@"items"]];
        [self.tableView reloadData];
    }];
    
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
	return [self.fourSquareResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fourSquareCell" forIndexPath:indexPath];

	cell.textLabel.text = self.fourSquareResults[indexPath.row][@"venue"][@"name"];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.delegate selectedVeneuWithName:self.fourSquareResults[indexPath.row][@"venue"][@"name"]
                               latitiude:self.fourSquareResults[indexPath.row][@"venue"][@"location"][@"lat"]
                               longitude:self.fourSquareResults[indexPath.row][@"venue"][@"location"][@"lng"]
                                  rating:self.fourSquareResults[indexPath.row][@"venue"][@"rating"]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelTapped:(id)sender {
	[self dismissViewControllerAnimated:YES completion: ^{}];
}

@end
