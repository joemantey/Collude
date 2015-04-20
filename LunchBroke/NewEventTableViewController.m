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
#import "EventIcon.h"
#import "EventIconCollectionViewCell.h"
#import "EventTableViewController.h"
#import "fourSquareViewControllerTableViewController.h"
#import <UINavigationBar+Addition.h>
#import "Locations.h"


@interface NewEventTableViewController () <fourSquareLocationInfoDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *timeDisplay;
@property (weak, nonatomic) IBOutlet UITextField *eventLocationField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *iconField;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDate *selectedDate;
@property (nonatomic) BOOL datePickerIsShowing;
@property (strong, nonatomic) fourSquare *latAndLong;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *iconArray;
@property (strong, nonatomic) EventIcon *eventIcon;

@property (strong, nonatomic) NSMutableArray *eventCoordinates;
@property (strong, nonatomic) NSString *eventName;
@property (nonatomic) BOOL didFourSquare;

- (IBAction)cancelButton:(id)sender;
- (IBAction)pickerDateChanged:(id)sender;
- (IBAction)savebutton:(id)sender;
- (IBAction)fourSquareSearch:(id)sender;

@end

@implementation NewEventTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self iconArray];
    
    self.didFourSquare = NO;

    //set the color of the bar
    [self.navigationController.navigationBar setBarTintColor:[UIColor uig_kyotoEndColor]];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar hideBottomHairline];
    
    //turn the bar opaque
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self setupTimeDisplay];
    
    //collectionView Delegate
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}


#pragma mark Buttons

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)savebutton:(id)sender {
    NSDate *choosenDate = [self.datePicker date];
    
    Event *newEvent = [[Event alloc] init];
    newEvent.timeOfEvent = choosenDate;
    newEvent.manager = PFUser.currentUser;
    newEvent.eventName = self.nameField.text;
    newEvent.imageLabel =  self.eventIcon.iconLabel;

    if (self.didFourSquare) {
        newEvent.locationName = self.eventName;
        [newEvent.coordinates arrayByAddingObjectsFromArray:self.eventCoordinates];
    } else {
        newEvent.locationName = self.eventLocationField.text;
    }
    
    [newEvent.Attendees addObject:PFUser.currentUser];

    [newEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"fetchEventsNotification" object:nil userInfo:nil];
            }];
            
            NSLog(@"Save Success");
        } else {
            NSLog(@"%@",error.description);
        }
    }];
    
}

- (IBAction)fourSquareSearch:(id)sender {
    UINavigationController *temp = [[self storyboard] instantiateViewControllerWithIdentifier:@"fourSquareNavController"];
    
    fourSquareViewControllerTableViewController *fourSqNavCont = temp.viewControllers[0];
    
    fourSqNavCont.fourSqQuery = self.eventLocationField.text;
    
    fourSqNavCont.delegate = self;
    
    [self presentViewController:temp animated:YES completion:nil];
    
}

-(void)selectedVeneuWithName:(NSString *)name latitiude:(NSString *)latitude longitude:(NSString *)longitude {
    self.eventName = name;
    [self.eventCoordinates addObject:latitude];
    [self.eventCoordinates addObject:longitude];
    self.didFourSquare = YES;
    self.eventLocationField.text = name;
}

#pragma mark - Table view data source


- (void)setupTimeDisplay
{
    //The date formatter will inform which time options are shown on the date picker
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    //Set's the the defailt date to today's date
    NSDate *defaultDate = [NSDate date];
    
    //set the text and tint of the date formatter
    self.timeDisplay.text = [self.dateFormatter stringFromDate:defaultDate];
    self.timeDisplay.textColor = [self.timeDisplay tintColor];
    
    //set's the default state for the date picker to today's date
    self.selectedDate = defaultDate;
    
    //upon view did load, hide the date picker cell
    [self hideDatePickerCell];
}

//Since we are using a static tableview, we can use the constants to set parameters for our tableview. Using define, we can put all of our "magic numbers" in one place, in case we need to change them later.
#define kDatePickerIndex 3
#define dateTextCellIndex 2
#define collectionViewCellIndex 5
#define tallCellHeight 162


//If datePickerIsShowing, set the height of the cell to 164 (the hieght of a date picker). If !datePickerIsShowing, set the height of the cell to 0
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = self.tableView.rowHeight;
    
    if (indexPath.row == kDatePickerIndex){
        height = self.datePickerIsShowing ? tallCellHeight : 0.0f;
    }else if (indexPath.row == collectionViewCellIndex){
        height = tallCellHeight;
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



#pragma mark CollectionView Delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 50);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake( 8, 8, 8, 8);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.iconArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EventIconCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"eventIcon" forIndexPath:indexPath];
    
    EventIcon *currentIcon = self.iconArray[indexPath.item];
        
    cell.iconImage.image = currentIcon.iconImage;
    
    self.eventIcon = currentIcon;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 2)];
    
    lineView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:lineView];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.eventIcon = self.iconArray[indexPath.item];
    
    self.iconField.text = self.eventIcon.iconLabel;
    
}


#pragma mark Images and Icons


//IMPORTANT- The tags here are set to the filenames for a reason. There is no convenient way to get filenames of images once they are compiled.
-(NSArray *)iconArray{
    if (! _iconArray) {
        EventIcon *bar = [[EventIcon alloc]initWithLabel:@"Bar" andImage:[UIImage imageNamed:@"Bar.png"]];
        EventIcon *meal = [[EventIcon alloc]initWithLabel:@"Meal" andImage:[UIImage imageNamed:@"Meal.png"]];
        EventIcon *snack = [[EventIcon alloc]initWithLabel:@"Snack" andImage:[UIImage imageNamed:@"Snack.png"]];
        EventIcon *celebration = [[EventIcon alloc]initWithLabel:@"Celebration" andImage:[UIImage imageNamed:@"Celebration.png"]];
        EventIcon *nightlife = [[EventIcon alloc]initWithLabel:@"Nightlife" andImage:[UIImage imageNamed:@"Nightlife.png"]];
        EventIcon *sports = [[EventIcon alloc]initWithLabel:@"Sports" andImage:[UIImage imageNamed:@"Sports.png"]];
        EventIcon *study = [[EventIcon alloc]initWithLabel:@"Study" andImage:[UIImage imageNamed:@"Study.png"]];
        EventIcon *other = [[EventIcon alloc]initWithLabel:@"Other" andImage:[UIImage imageNamed:@"Other.png"]];
        
        _iconArray = [[NSMutableArray alloc] initWithArray:@[bar, meal, snack, celebration, nightlife, sports, study, other]];
    }
    
    return _iconArray;
}

#pragma mark Other helper methods

- (UIColor *)UIColorFromRGB:(NSInteger)rgbValue {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0
                           alpha:1.0];
}

@end
