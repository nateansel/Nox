//
//  SunriseNotificationsTableViewController.h
//  Sunset
//
//  Created by Nathan Ansel on 5/25/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SunriseNotificationsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
  NSMutableArray *tableData;
  NSUserDefaults *myDefaults;
  IBOutlet UIBarButtonItem *addButton;
}

- (void)addOrDeleteRows;
- (IBAction)addItem:(id)sender;
- (void)showPickerWithSender:(id)sender
           initialSelection0:(int)initialSelection0
           initialSelection1:(int)initialSelection1
                   deleteRow:(int)rowToDelete
     currentValueBeingEdited:(int)editValueToCheck;
- (BOOL)isItemDuplicate:(int)object;

@end
