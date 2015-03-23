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

@interface EventDetailController ()
- (IBAction)dismissTapped:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerOutlet;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EventDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setUpGradient];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)dismissTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 25;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attendeeCell" forIndexPath:indexPath];
    
    cell.textLabel.text = @"Names of attendees";
    
    NSLog(@"This code ran");
    return cell;
}

//- (IBAction)saveTapped:(id)sender {
//    
//    NSString *nameField = self.nameField.text;
//    PFObject *newEvent = [PFObject objectWithClassName:@"Event"];
//    newEvent[@"location"] = nameField;
//    
//    NSDate *choosenDate = [self.datePickerOutlet date];
//    
//    newEvent[@"date"] = choosenDate;
//    
//    NSLog(@"choosenDate: %@", choosenDate);
//    
//    [newEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            [self dismissViewControllerAnimated:YES completion:nil];
//            NSLog(@"Save Success");
//        } else {
//            NSLog(@"%@",error.description);
//        }
//    }];
//}
@end
