//
//  LocationsTableViewController.m
//  LnchBrkr
//
//  Created by Ian Smith on 3/16/15.
//  Copyright (c) 2015 Ian Smith. All rights reserved.
//

#import "LocationsTableViewController.h"
#import <Parse/Parse.h>
#import "Locations.h"
#import <UIColor+uiGradients.h>

@interface LocationsTableViewController ()

@end

@implementation LocationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setColors];
    [self fetchLocations];
    [self.tableView reloadData];
    
    
}


-(void)setColors
{
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor uig_namnStartColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.startPoint = CGPointZero;
    gradient.endPoint = CGPointMake(0, 1);
    gradient.colors = [NSArray arrayWithObjects: (id)[[UIColor uig_shrimpyStartColor] CGColor], (id)[[UIColor uig_mangoPulpStartColor]CGColor], nil];
    
//    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self fetchLocations];
}

-(void) fetchLocations
{
    PFQuery *locationCount = [PFQuery queryWithClassName:@"Locations"];
    [locationCount findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.locationArray = [NSMutableArray arrayWithArray:objects];
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
    return [self.locationArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell" forIndexPath:indexPath];
//    
//     Configure the cell...
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(500, 50, 20, 20)];
   imageView.image = [UIImage imageNamed:@"DJ-100.png"]
    ;
    
    [cell.contentView addSubview:imageView];
//    UIImage *img = [UIImage imageNamed:@"anyImageName"];
//    img =(UIImage *)[cell.contentView viewWithTag:1];


// Locations *location = self.locationArray[indexPath.row];
//    cell.textLabel.text = location[@"Name"];
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [indexPath row] * 2; // your dynamic height...
//}


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



@end
