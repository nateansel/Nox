//
//Copyright (c) 2011, Tim Cinel
//All rights reserved.
//
//Redistribution and use in source and binary forms, with or without
//modification, are permitted provided that the following conditions are met:
//* Redistributions of source code must retain the above copyright
//notice, this list of conditions and the following disclaimer.
//* Redistributions in binary form must reproduce the above copyright
//notice, this list of conditions and the following disclaimer in the
//documentation and/or other materials provided with the distribution.
//* Neither the name of the <organization> nor the
//names of its contributors may be used to endorse or promote products
//derived from this software without specific prior written permission.
//
//THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
//DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//åLOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "ActionSheetStringPicker.h"

@interface ActionSheetStringPicker()
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,assign) NSInteger selectedIndex0;
@property (nonatomic,assign) NSInteger selectedIndex1;
@property (nonatomic,assign) NSArray *duplicatesArrayToCheck;
@property (nonatomic,assign) UIPickerView *picker;
@end

@implementation ActionSheetStringPicker

+ (instancetype)showPickerWithTitle:(NSString *)title
                               rows:(NSArray *)strings
                  initialSelection0:(NSInteger)index0
                  initialSelection1:(NSInteger)index1
                          doneBlock:(ActionStringDoneBlock)doneBlock
                        cancelBlock:(ActionStringCancelBlock)cancelBlockOrNil
                             origin:(id)origin
             duplicatesArrayToCheck:(NSArray *)duplicatesArrayToCheck {
  ActionSheetStringPicker * picker = [[ActionSheetStringPicker alloc] initWithTitle:title rows:strings initialSelection0:(NSInteger)index0 initialSelection1:(NSInteger)index1 doneBlock:doneBlock cancelBlock:cancelBlockOrNil origin:origin];
  picker.duplicatesArrayToCheck = duplicatesArrayToCheck;
  [picker showActionSheetPicker];
  return picker;
}

+ (instancetype)showPickerWithTitle:(NSString *)title
                               rows:(NSArray *)strings
                  initialSelection0:(NSInteger)index0
                  initialSelection1:(NSInteger)index1
                          doneBlock:(ActionStringDoneBlock)doneBlock
                        cancelBlock:(ActionStringCancelBlock)cancelBlockOrNil
                             origin:(id)origin {
    ActionSheetStringPicker * picker = [[ActionSheetStringPicker alloc] initWithTitle:title rows:strings initialSelection0:(NSInteger)index0 initialSelection1:(NSInteger)index1 doneBlock:doneBlock cancelBlock:cancelBlockOrNil origin:origin];
    [picker showActionSheetPicker];
    return picker;
}

- (instancetype)initWithTitle:(NSString *)title
                         rows:(NSArray *)strings
            initialSelection0:(NSInteger)index0
            initialSelection1:(NSInteger)index1
                    doneBlock:(ActionStringDoneBlock)doneBlock
                  cancelBlock:(ActionStringCancelBlock)cancelBlockOrNil
                       origin:(id)origin {
    self = [self initWithTitle:title rows:strings initialSelection0:(NSInteger)index0 initialSelection1:(NSInteger)index1 target:nil successAction:nil cancelAction:nil origin:origin];
    if (self) {
        self.onActionSheetDone = doneBlock;
        self.onActionSheetCancel = cancelBlockOrNil;
    }
    return self;
}

+ (instancetype)showPickerWithTitle:(NSString *)title
                               rows:(NSArray *)data
                  initialSelection0:(NSInteger)index0
                  initialSelection1:(NSInteger)index1
                             target:(id)target
                      successAction:(SEL)successAction
                       cancelAction:(SEL)cancelActionOrNil
                             origin:(id)origin {
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:title rows:data initialSelection0:(NSInteger)index0 initialSelection1:(NSInteger)index1 target:target successAction:successAction cancelAction:cancelActionOrNil origin:origin];
    [picker showActionSheetPicker];
    return picker;
}

- (instancetype)initWithTitle:(NSString *)title
                         rows:(NSArray *)data
            initialSelection0:(NSInteger)index0
            initialSelection1:(NSInteger)index1
                       target:(id)target
                successAction:(SEL)successAction
                 cancelAction:(SEL)cancelActionOrNil
                       origin:(id)origin {
    self = [self initWithTarget:target successAction:successAction cancelAction:cancelActionOrNil origin:origin];
    if (self) {
      self.data = data;
      self.selectedIndex0 = index0;
      self.selectedIndex1 = index1;
      self.title = title;
    }
    return self;
}


- (UIView *)configuredPickerView {
    if (!self.data)
        return nil;
    CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIPickerView *stringPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    stringPicker.delegate = self;
    stringPicker.dataSource = self;
    [stringPicker selectRow:self.selectedIndex0 inComponent:0 animated:NO];
    [stringPicker selectRow:self.selectedIndex1 inComponent:1 animated:NO];
    if (self.data.count == 0) {
        stringPicker.showsSelectionIndicator = NO;
        stringPicker.userInteractionEnabled = NO;
    } else {
        stringPicker.showsSelectionIndicator = YES;
        stringPicker.userInteractionEnabled = YES;
    }

    //need to keep a reference to the picker so we can clear the DataSource / Delegate when dismissing
    self.pickerView = stringPicker;
    self.picker = stringPicker;

    return stringPicker;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin {
    if (self.onActionSheetDone) {
//      if (self.selectedIndex0 == 0 && self.selectedIndex1 == 0) {
//        self.selectedIndex1 = 1;
//      }
      id selectedObject0 = ([self.data[0] count] > 0) ? (self.data)[0][(NSUInteger) self.selectedIndex0] : nil;
      id selectedObject1 = ([self.data[1] count] > 0) ? (self.data)[1][(NSUInteger) self.selectedIndex1] : nil;
      _onActionSheetDone(self, selectedObject0, selectedObject1);
      return;
    }
    else if (target && [target respondsToSelector:successAction]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:successAction withObject:@(self.selectedIndex0) withObject:origin];
#pragma clang diagnostic pop
        return;
    }
    NSLog(@"Invalid target/action ( %s / %s ) combination used for ActionSheetPicker and done block is nil.", object_getClassName(target), sel_getName(successAction));
}

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin {
    if (self.onActionSheetCancel) {
        _onActionSheetCancel(self);
        return;
    }
    else if (target && cancelAction && [target respondsToSelector:cancelAction]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:cancelAction withObject:origin];
#pragma clang diagnostic pop
    }
}

#pragma mark - UIPickerViewDelegate / DataSource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  if (component == 0) {
    self.selectedIndex0 = row;
  } else {
    self.selectedIndex1 = row;
  }
  
  if (self.selectedIndex0 == 0 && self.selectedIndex1 == 0) {
    self.selectedIndex1 = 1;
    [self.picker selectRow:1 inComponent:1 animated:YES];
  }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.data.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.data[component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  id obj = self.data[component][row];

  // return the object if it is already a NSString,
  // otherwise, return the description, just like the toString() method in Java
  // else, return nil to prevent exception

  if ([obj isKindOfClass:[NSString class]])
      return obj;

  if ([obj respondsToSelector:@selector(description)])
      return [obj performSelector:@selector(description)];

  return nil;
}

//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    return pickerView.frame.size.width - 30;
//}

@end
