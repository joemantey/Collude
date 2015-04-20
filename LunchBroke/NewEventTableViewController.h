//
//  NewEventTableViewController.h
//  LnchBrkr
//
//  Created by Joseph Smalls-Mantey on 3/18/15.
//  Copyright (c) 2015 Ian Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewEventTableViewController : UITableViewController <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


@property (strong, nonatomic) NSString *query;



@end
