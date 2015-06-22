//
//  SunsetNotificationsTableViewController.h
//  Sunset
//
//  Created by Nathan Ansel on 6/11/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SunsetNotificationsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
  NSMutableArray *tableData;
  NSUserDefaults *myDefaults;
  IBOutlet UIBarButtonItem *addButton;
}

- (void)addOrDeleteRows;
- (IBAction)addItem:(id)sender;

@end