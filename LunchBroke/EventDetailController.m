//
//  AddLocationViewController.m
//  LnchBrkr
//
//  Created by Ian Smith on 3/16/15.
//  Copyright (c) 2015 Ian Smith. All rights reserved.
//

#import "EventDetailController.h"
#import <Parse/Parse.h>

@interface EventDetailController ()
- (IBAction)dismissTapped:(id)sender;
- (IBAction)saveTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerOutlet;

@end

@implementation EventDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)saveTapped:(id)sender {
    
    NSString *nameField = self.nameField.text;
    PFObject *newEvent = [PFObject objectWithClassName:@"Event"];
    newEvent[@"location"] = nameField;
    
    NSDate *choosenDate = [self.datePickerOutlet date];
    
    newEvent[@"date"] = choosenDate;
    
    NSLog(@"choosenDate: %@", choosenDate);
    
    [newEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self dismissViewControllerAnimated:YES completion:nil];
            NSLog(@"Save Success");
        } else {
            NSLog(@"%@",error.description);
        }
    }];
}
@end
