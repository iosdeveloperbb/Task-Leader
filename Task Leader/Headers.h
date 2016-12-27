//
//  Headers.h
//  Task Leader
//
//  Created by Balajibabu S.G. on 25/12/16.
//  Copyright © 2016 Balajibabu S.G. All rights reserved.
//

#ifndef Headers_h
#define Headers_h

#pragma mark- Import Files

#import "MGSwipeButton.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeTableCell-umbrella.h"
#import "JVFloatLabeledTextField.h"
#import "JVFloatLabeledTextView.h"
#import "NSString+TextDirectionality.h"
#import "DoneCancelNumberPadToolbar.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "Utilities.h"
#import "NavigationButtonItem.h"
#import "DateConverter.h"

#pragma mark- Time Calculation

#define ONE_MIN 60
#define ONE_HR 60*60
#define ONE_DAY 60*60*24
#define ONE_MONTH 60*60*24*30
#define ONE_YEAR 60*60*24*30*12

#pragma mark- CoreData Entity

#define kEntityName @"Task"
#define kContactName @"contactName"
#define kEmail @"email"
#define kFormDescription @"formDescription"
#define kStatus @"status"
#define kTaskName @"taskName"
#define kReminderContent @"reminderContent"
#define kTaskNumber @"taskNumber"
#define kContent @"content"
#define kDueDate @"dueDate"
#define kPriority @"priority"
#define kGroup @"group"
#define kClassification @"classification"
#define kMessageTime @"messageTime"
#define kPhone @"phone"


#endif /* Headers_h */
