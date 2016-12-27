//
//  TaskListViewController.h
//  Task Leader
//
//  Created by Balajibabu S.G. on 25/12/16.
//  Copyright © 2016 Balajibabu S.G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Headers.h"
#import "AddTaskViewController.h"
#import "CoreDataHandler.h"
#import <UserNotifications/UserNotifications.h>

typedef enum {
    OFF,
    ON,
} FilterStatus;


@interface TaskListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MGSwipeTableCellDelegate>



@property (weak, nonatomic) IBOutlet UIView *segmentContainer;
@property (strong, nonatomic) IBOutlet UISegmentedControl *statusSegment;
@property (strong, nonatomic) IBOutlet UISegmentedControl *prioritySegment;
@property (strong, nonatomic) IBOutlet UITableView *mailTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *mailSearchBar;


@end

