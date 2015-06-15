//
//  SunriseNotificationsTableViewController.m
//  Sunset
//
//  Created by Nathan Ansel on 5/25/15.
//  Copyright (c) 2015 Chase McCoy. All rights reserved.
//

#import "SunriseNotificationsTableViewController.h"

@interface SunriseNotificationsTableViewController ()

@end

@implementation SunriseNotificationsTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(addOrDeleteRows)];
  self.navigationItem.rightBarButtonItem = editButton;
  
  addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
  self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
  
  myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.nathanchase.sunset"];
  
  tableData = [[myDefaults objectForKey:@"sunriseNotificationsArray"] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)addOrDeleteRows {
  if(self.editing) {
    [super setEditing:NO animated:YES];
    [self setEditing:NO animated:YES];
    [self.tableView reloadData];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(addOrDeleteRows)];
    self.navigationItem.rightBarButtonItem = editButton;
    self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
    //NSLog([NSString stringWithFormat:@"Editing: %d", self.editing]);
  } else {
    [super setEditing:YES animated:YES];
    [self setEditing:YES animated:YES];
    [self.tableView reloadData];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addOrDeleteRows)];
    self.navigationItem.rightBarButtonItem = doneButton;
    self.navigationItem.leftBarButtonItem = addButton;
    //NSLog([NSString stringWithFormat:@"Editing: %d", self.editing]);
  }
  
  [myDefaults setObject:tableData forKey:@"sunriseNotificationsArray"];
  [myDefaults synchronize];
}

- (void)addItem:(id)sender {
  if (tableData.count == 20) {
    UIAlertController *maxErrorAlert = [UIAlertController alertControllerWithTitle:@"Notification Limit"
                                                                                 message:@"You have reached the maximum amount of notifications supported."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    [maxErrorAlert addAction:defaultAction];
    [self presentViewController:maxErrorAlert
                       animated:YES
                     completion:nil];
  } else {
    [self showPickerWithSender:sender
             initialSelection0:1
             initialSelection1:0
                     deleteRow:-1
       currentValueBeingEdited:-1];
  }
}

- (void)showPickerWithSender:(id)sender initialSelection0:(int)initialSelection0 initialSelection1:(int)initialSelection1 deleteRow:(int)rowToDelete currentValueBeingEdited:(int)editValueToCheck {
  NSArray *data = @[ @[@"0",@"1",@"2"],
                     @[@"0",@"5",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55"]];
  
  [ActionSheetStringPicker showPickerWithTitle:@"Select a time"
                                          rows:data
                             initialSelection0:initialSelection0
                             initialSelection1:initialSelection1
                                     doneBlock:^(ActionSheetStringPicker *picker, id selectedValue0, id selectedValue1) {
                                                 NSLog(@"Picker: %@", picker);
                                                 NSLog(@"Selected Value: %@", selectedValue0);
                                                 NSLog(@"Selected Value: %@", selectedValue1);
                                                 NSInteger minutes = [selectedValue0 integerValue] * 60 + [selectedValue1 integerValue];
                                                 if (editValueToCheck != (int) minutes) {
                                                   if ([self isItemDuplicate:(int) minutes]) {
                                                     UIAlertController *duplicateErrorAlert = [UIAlertController alertControllerWithTitle:@"Duplicate Notification"
                                                                                                                                  message:@"You already have a notification set up for that time. Please choose another time or cancel."
                                                                                                                           preferredStyle:UIAlertControllerStyleAlert];
                                                     UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                                                                             style:UIAlertActionStyleDefault
                                                                                                           handler:^(UIAlertAction *action) {
                                                                                                                     [self showPickerWithSender:sender
                                                                                                                              initialSelection0:(int) [selectedValue0 integerValue]
                                                                                                                              initialSelection1:(int) [selectedValue1 integerValue] / 5
                                                                                                                                      deleteRow:rowToDelete
                                                                                                                        currentValueBeingEdited:editValueToCheck];
                                                                                                                   }];
                                                     UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                                                            style:UIAlertActionStyleCancel
                                                                                                          handler:^(UIAlertAction *cancel) {}];
                                                     [duplicateErrorAlert addAction:defaultAction];
                                                     [duplicateErrorAlert addAction:cancelAction];
                                                     [self presentViewController:duplicateErrorAlert
                                                                        animated:YES
                                                                      completion:nil];
                                                   } else {
                                                     if (rowToDelete != -1) {
                                                       [tableData removeObjectAtIndex:rowToDelete];
                                                     }
                                                     [self addObjectAtCorrectIndex:(int) minutes];
                                                     [self.tableView reloadData];
                                                   }
                                                 }
                                               }
                                   cancelBlock:^(ActionSheetStringPicker *picker) {
                                                 NSLog(@"Block Picker Canceled");
                                               }
                                        origin:sender];
}

- (BOOL)isItemDuplicate:(int)object {
  for (int i = 0; i < tableData.count; i++) {
    if ([[tableData objectAtIndex:i] integerValue] == object) {
      return YES;
    }
  }
  
  return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // #warning Potentially incomplete method implementation.
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // #warning Incomplete method implementation.
  // Return the number of rows in the section.
  return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.editingAccessoryType = UITableViewCellAccessoryDetailButton;
  }
  
  NSString *minuteString;
  int minutes = (int) [[tableData objectAtIndex:indexPath.row] integerValue];
  int hours = minutes / 60;
  if (hours > 0) {
    minutes = minutes - (60 * hours);
    if (minutes > 0) {
      minuteString = [NSString stringWithFormat:@" %d minutes",minutes];
    } else {
      minuteString = @"";
    }
    if (hours == 1) {
      cell.textLabel.text = [NSString stringWithFormat:@"%d hour%@", hours, minuteString];
    } else {
      cell.textLabel.text = [NSString stringWithFormat:@"%d hours%@", hours, minuteString];
    }
  } else {
    cell.textLabel.text = [NSString stringWithFormat:@"%d minutes", minutes];
  }
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"h:mm a"];
  NSDate *nextSunrise = [[[myDefaults objectForKey:@"upcomingSunrises"] objectAtIndex:0] dateByAddingTimeInterval:((minutes + hours * 60) * -60)];
  cell.detailTextLabel.text = [dateFormatter stringFromDate:nextSunrise];
  
  return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
  int minutes = (int) [[tableData objectAtIndex:indexPath.row] integerValue];
  int hours = minutes / 60;
  if (hours > 0) {
    minutes = minutes - (60 * hours);
  }
  minutes = minutes / 5;
  
  [self showPickerWithSender:self.tableView
           initialSelection0:hours
           initialSelection1:minutes
                   deleteRow:(int) indexPath.row
     currentValueBeingEdited:(int) [[tableData objectAtIndex:indexPath.row] integerValue]];
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                            forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the row from the data source
    [tableData removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  }
}

- (void)addObjectAtCorrectIndex: (int) object {
  for (int i = 0; i < tableData.count; i++) {
    if ([tableData[i] integerValue] > object) {
      [tableData insertObject:[NSNumber numberWithInt:object] atIndex:i];
      return;
    }
  }
  
  [tableData addObject:[NSNumber numberWithInt:object]];
  return;
}

@end
