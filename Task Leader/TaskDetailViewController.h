//
//  TaskDetailViewController.h
//  Task Leader
//
//  Created by Balajibabu S.G. on 27/12/16.
//  Copyright © 2016 Balajibabu S.G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Details.h"
#import "Headers.h"

@interface TaskDetailViewController : UIViewController

@property (strong, nonatomic) Details *selectedDetails;

@property (strong, nonatomic) IBOutlet UILabel *contactName;
@property (strong, nonatomic) IBOutlet UILabel *messageTime;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UILabel *taskNumber;
@property (strong, nonatomic) IBOutlet UILabel *formDescription;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;

@end
