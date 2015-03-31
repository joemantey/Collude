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
@property(nonatomic)CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lng;


@end

@implementation fourSquareViewControllerTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _locationManager =[[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    fourSquare *fourSq = [[fourSquare alloc] init];
    [fourSq getNearby4SquareLocationsWithCompletionBlock:^(id results) {
        (NSDictionary *)results;
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

- (IBAction)cancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end