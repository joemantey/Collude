//
//  NewEventTableViewController.m
//  LnchBrkr
//
//  Created by Joseph Smalls-Mantey on 3/18/15.
//  Copyright (c) 2015 Ian Smith. All rights reserved.
//

#import "NewEventTableViewController.h"
#import <Parse/Parse.h>
#import <UIColor+uiGradients.h>
#import "fourSquare.h"
#import "Event.h"

@interface NewEventTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *timeDisplay;
@property (weak, nonatomic) IBOutlet UITextField *eventLocationField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDate *selectedDate;
@property (nonatomic) BOOL datePickerIsShowing;
@property (strong, nonatomic) fourSquare *latAndLong;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)cancelButton:(id)sender;
- (IBAction)pickerDateChanged:(id)sender;
- (IBAction)savebutton:(id)sender;
- (IBAction)fourSquareSearch:(id)sender;

@end

@implementation NewEventTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    //set the color of the bar
    [self.navigationController.navigationBar setBarTintColor:[UIColor uig_namnStartColor]];
    
    //turn the bar opaque
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self setupTimeDisplay];
    
    self.latAndLong = [[fourSquare alloc] init];
    [self.latAndLong getNearby4SquareLocations:^(NSArray *array) {}];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    //    [self.tableView setBackgroundView:<#(UIView *)#>:[UIColor clearColor]];
    //    [self.tableView setBackgroundView:nil];
}

#pragma mark - Table view data source


- (void)setupTimeDisplay
{
    
    //The date formatter will inform which time options are shown on the date picker
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    //Set's the the defailt date to today's date
    NSDate *defaultDate = [NSDate date];
    
    //set the text and tint of the date formatter
    self.timeDisplay.text = [self.dateFormatter stringFromDate:defaultDate];
    self.timeDisplay.textColor = [self.tableView tintColor];
    
    //set's the default state for the date picker to today's date
    self.selectedDate = defaultDate;
    
    //upon view did load, hide the date picker cell
    [self hideDatePickerCell];
}

//Since we are using a static tableview, we can use the constants to set parameters for our tableview. Using define, we can put all of our "magic numbers" in one place, in case we need to change them later.
#define kDatePickerIndex 3
#define dateTextCellIndex 2
#define kDatePickerCellHeight 164

//If datePickerIsShowing, set the height of the cell to 164 (the hieght of a date picker). If !datePickerIsShowing, set the height of the cell to 0
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = self.tableView.rowHeight;
    
    if (indexPath.row == kDatePickerIndex){
        height = self.datePickerIsShowing ? kDatePickerCellHeight : 0.0f;
    }
    
    return height;
}

//when the date picker changes, set it's input to reflect in the date picker text
- (IBAction)pickerDateChanged:(id)sender {
    self.timeDisplay.text =  [self.dateFormatter stringFromDate:[self.datePicker date]];
    
    self.selectedDate = [self.datePicker date];
}

//When the row with the date displayed is selected....
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == dateTextCellIndex){
        
        //If the datePickerIsShowing...
        if (self.datePickerIsShowing){
            //...hide it!
            [self hideDatePickerCell];
            //But if the !datePickerIsShowing
        }else {
            //...show it!
            [self showDatePickerCell];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//when this method is called...
- (void)showDatePickerCell {
    
    //...change the BOOLEAN to indicate the the date picker is (about to be) shown...
    self.datePickerIsShowing = YES;
    
    //...refresh the tableview...
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    //...seems like a good time to stop hiding the date picker...
    self.datePicker.hidden = NO;
    //Now some setup. Turn the date picker clear so we can have it fade in during our animation.
    self.datePicker.alpha = 0.0f;
    
    //Let's get our Walt Disney on and animate the appearance of this date picker.
    [UIView animateWithDuration:0.25 animations:^{
        
        self.datePicker.alpha = 1.0f;
        
    }];
}

- (void)hideDatePickerCell {
    
    //Toggle the BOOL to represent the datePickerCell is (about to be) hidden
    self.datePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    //Animation time again. This time were turning the date picker clear.
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.datePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         //when we're done animating, hide the picker
                         self.datePicker.hidden = YES;
                         //update picker to show date
                         self.selectedDate = [self.datePicker date];
                     }];
}


/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

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

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)savebutton:(id)sender {
    NSDate *choosenDate = [self.datePicker date];
    
    NSString *nameField = self.nameField.text;
    Event *newEvent = [[Event alloc] init];
    newEvent.eventName = nameField;
    newEvent.timeOfEvent = choosenDate;
    newEvent.manager = PFUser.currentUser;
    [newEvent.Attendees addObject:PFUser.currentUser];
//  newEvent.location = SOMETHING HERE
    
    [newEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self dismissViewControllerAnimated:YES completion:nil];
            NSLog(@"Save Success");
        } else {
            NSLog(@"%@",error.description);
        }
    }];
}

- (IBAction)fourSquareSearch:(id)sender {
}



@end
