//
//  TaskListViewController.m
//  Task Leader
//
//  Created by Balajibabu S.G. on 25/12/16.
//  Copyright © 2016 Balajibabu S.G. All rights reserved.
//

#import "TaskListViewController.h"
#import "TaskDetailViewController.h"



@interface TaskListViewController (){
    UILabel *noLabel;
    NSMutableArray *allMailData, *localNotificationList;
    NSArray *mailData, *prevMailData;
    FilterStatus filterStatus;
    UIRefreshControl *refreshControl;
}


@end

@implementation TaskListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self setNavigationBar];
    [self setTableView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self resetToInitialSettings];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.prioritySegment.selectedSegmentIndex = 0;
    self.statusSegment.selectedSegmentIndex = 0;
    [self showStatusSegment];
}

- (void)showStatusSegment
{
    if ([[self.prioritySegment superview] isEqual:self.segmentContainer]) {
        [self.prioritySegment removeFromSuperview];
    }
    self.statusSegment.frame = CGRectMake(0, 0, CGRectGetWidth(self.segmentContainer.frame), CGRectGetHeight(self.statusSegment.frame));
    [self.segmentContainer addSubview:self.statusSegment];
}

- (void)showPrioritySegment
{
    if ([[self.statusSegment superview] isEqual:self.segmentContainer]) {
        [self.statusSegment removeFromSuperview];
    }
    self.prioritySegment.frame = CGRectMake(0, 0, CGRectGetWidth(self.segmentContainer.frame), CGRectGetHeight(self.statusSegment.frame));
    [self.segmentContainer addSubview:self.prioritySegment];
}

- (void)resetSegment
{
    self.prioritySegment.selectedSegmentIndex = 0;
    self.statusSegment.selectedSegmentIndex = 0;
    [self setTableView];
}


#pragma mark - Initial settings on loading

- (void)pullToRefresh
{
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor purpleColor];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self
                       action:@selector(refreshTableview)
             forControlEvents:UIControlEventValueChanged];
    [self.mailTableView addSubview:refreshControl];
}

- (void)setNavigationBar
{
    self.navigationItem.title = @"Task List";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor blackColor];

    NavigationButtonItem *addButton = [[NavigationButtonItem alloc] initWithImage:@"AddTask.png" WithCompletionHandler:^{
        AddTaskViewController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"addTaskViewController"];
        UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:nav];
        [self presentViewController:navBar animated:YES completion:nil];
    }];
    addButton.scale = 0.5f;
    UIBarButtonItem *rightButton = [addButton getButtonWithSide:Right];
    
    NavigationButtonItem *filterButton = [[NavigationButtonItem alloc] initWithImage:@"Filter.png" WithCompletionHandler:^{
        [self showAlertAction];
    }];
    filterButton.scale = 0.4f;
    UIBarButtonItem *rightButton1 = [filterButton getButtonWithSide:Right];
    self.navigationItem.rightBarButtonItems = @[rightButton,rightButton1];
    filterStatus = OFF;
}

- (void)resetNavigationBar
{
    NavigationButtonItem *addButton = [[NavigationButtonItem alloc] initWithImage:@"AddTask.png" WithCompletionHandler:^{
        AddTaskViewController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"addTaskViewController"];
        UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:nav];
        [self presentViewController:navBar animated:YES completion:nil];
    }];
    addButton.scale = 0.5f;
    UIBarButtonItem *rightButton = [addButton getButtonWithSide:Right];
    
    NavigationButtonItem *filterButton = [[NavigationButtonItem alloc] initWithImage:@"FilterFilled.png" WithCompletionHandler:^{
        [self showAlertAction];
    }];
    filterButton.scale = 0.4f;
    UIBarButtonItem *rightButton1 = [filterButton getButtonWithSide:Right];
    self.navigationItem.rightBarButtonItems = @[rightButton,rightButton1];
    
    if (filterStatus==OFF) {
        [self animateFilterButton];
    }
    filterStatus = ON;
}

- (void)animateFilterButton
{
    UIView *animateView = self.navigationItem.rightBarButtonItems[1].customView;
    animateView.transform = CGAffineTransformScale(animateView.transform, 0.1, 0.1);
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:30.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        animateView.transform = CGAffineTransformScale(animateView.transform, 10, 10);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showAlertAction
{
    UIAlertAction *filterStatus1 = [UIAlertAction actionWithTitle:@"Status" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showStatusSegment];
        [self resetSegment];
        [self setNavigationBar];
    }];
    
    UIAlertAction *filterPriority = [UIAlertAction actionWithTitle:@"Priority" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showPrioritySegment];
        [self resetSegment];
        [self setNavigationBar];
    }];
    
    UIAlertController *alert = [[Utilities sharedInstance] createAlertWithAction:@"Filter" withMessage:@"Select a Category" withCancelButton:@"Cancel" withTarget:self];
    [alert addAction:filterStatus1];
    [alert addAction:filterPriority];
}

- (void)setTableView
{
    self.statusSegment.selectedSegmentIndex = 0;
    self.prioritySegment.selectedSegmentIndex = 0;
    allMailData = [[NSMutableArray alloc] initWithArray:[CoreDataHandler fetchFormWithPredicate:nil]];
    allMailData = [[[allMailData reverseObjectEnumerator] allObjects] mutableCopy];
    mailData = allMailData;
    prevMailData = mailData;
    
    self.mailTableView.delegate = self;
    self.mailTableView.dataSource = self;
    
    localNotificationList = [[NSMutableArray alloc] init];
    
    [self setLocalNotification];
    
    if (mailData.count==0) {
        self.mailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.mailTableView reloadData];
    }
    else {
        self.mailTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.mailTableView reloadData];
        [self.mailTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    self.mailTableView.bounces = YES;
    self.mailTableView.tableFooterView = [[UIView alloc] init];
}

- (void)refreshTableview
{
    mailData = allMailData;
    prevMailData = mailData;
    [self.mailTableView reloadData];
    [self resetToInitialSettings];
    [refreshControl endRefreshing];
    [self.mailTableView setContentOffset:CGPointZero animated:YES];
}

- (void)resetToInitialSettings
{
    self.statusSegment.selectedSegmentIndex = 0;
    self.prioritySegment.selectedSegmentIndex = 0;
    
    [self.mailSearchBar resignFirstResponder];
    self.mailSearchBar.text = @"";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.mailSearchBar setShowsCancelButton:NO animated:YES];
    [self setNavigationBar];
}

#pragma mark - Tableview Delegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (mailData.count!=0) {
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.backgroundView = nil;
        return mailData.count;
        
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
        
        messageLabel.text = @"No Tasks";
        messageLabel.textColor = [UIColor grayColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont systemFontOfSize:20.0f];
        [messageLabel sizeToFit];
        
        tableView.backgroundView = messageLabel;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGSwipeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
    if (cell == nil) {
        
        cell = [[MGSwipeTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    //Configure right buttons
    cell.delegate = self;
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor]],
                          [MGSwipeButton buttonWithTitle:@"Close" backgroundColor:[UIColor colorWithRed:18/255.0f  green:180/255.0f  blue:147/255.0f  alpha:1.0]],
                          [MGSwipeButton buttonWithTitle:@"Pickup" backgroundColor:[UIColor lightGrayColor]],
                          [MGSwipeButton buttonWithTitle:@"Move" backgroundColor:[UIColor blackColor]]];
    cell.rightSwipeSettings.transition = MGSwipeStateSwipingLeftToRight;
    
    
    //Configure Cell Data
    Details *currentDetails = (Details *)[mailData objectAtIndex:indexPath.row];

    UILabel *ticketNumber = (UILabel *)[cell viewWithTag:2];
    UILabel *mailDescription = (UILabel *)[cell viewWithTag:3];
    UILabel *contactName = (UILabel *)[cell viewWithTag:4];
    UILabel *status = (UILabel *)[cell viewWithTag:5];
    UIImageView *priority = (UIImageView *)[cell viewWithTag:6];
    UILabel *messageTime = (UILabel *)[cell viewWithTag:7];
    UIView *statusBG = (UIView *)[cell viewWithTag:8];
    UILabel *assigneName = (UILabel *)[cell viewWithTag:9];
    UIImageView *groupImage = (UIImageView *)[cell viewWithTag:10];
    
    ticketNumber.text = currentDetails.taskNumber;
    mailDescription.text = currentDetails.formDescription;
    contactName.text = currentDetails.contactName;
    status.text = currentDetails.status;
    messageTime.text = [self getMessageTime:currentDetails.messageTime];
    assigneName.text = @"Balajibabu";
    
    if ([currentDetails.priority isEqualToString:@"High"]) {
        priority.image = [UIImage imageNamed:@"high.png"];
        priority.hidden = NO;
    }
    else if ([currentDetails.priority isEqualToString:@"Medium"]) {
        priority.image = [UIImage imageNamed:@"Medium.png"];
        priority.hidden = NO;
    }
    else if ([currentDetails.priority isEqualToString:@"Low"]) {
        priority.image = [UIImage imageNamed:@"Low.png"];
        priority.hidden = NO;
    }
    else {
        priority.hidden = YES;
    }

    if ([status.text isEqualToString:@"Closed"]) {
        statusBG.backgroundColor = [UIColor colorWithRed:(11/255.0) green:(162/255.0) blue:(80/255.0) alpha:1.0];
    }
    else if ([status.text isEqualToString:@"On Hold"]){
        statusBG.backgroundColor = [UIColor colorWithRed:(226/255.0) green:(30/255.0) blue:(80/255.0) alpha:1.0];
    }
    else {
        statusBG.backgroundColor = [UIColor colorWithRed:(11/255.0) green:(79/255.0) blue:(179/255.0) alpha:1.0];
    }
    
    
    if ([currentDetails.group isEqualToString:@"Red Group"]) {
        groupImage.image = [UIImage imageNamed:@"RedGroup.png"];
    }
    else if ([currentDetails.group isEqualToString:@"Green Group"]) {
        groupImage.image = [UIImage imageNamed:@"GreenGroup.png"];
    }
    else if ([currentDetails.group isEqualToString:@"Blue Group"]) {
        groupImage.image = [UIImage imageNamed:@"BlueGroup.png"];
    }
    else if ([currentDetails.group isEqualToString:@"Grey Group"]) {
        groupImage.image = [UIImage imageNamed:@"GreyGroup.png"];
    }
    else if ([currentDetails.group isEqualToString:@"Yellow Group"]) {
        groupImage.image = [UIImage imageNamed:@"YellowGroup.png"];
    }
    else if ([currentDetails.group isEqualToString:@"DarkGreen Group"]) {
        groupImage.image = [UIImage imageNamed:@"DGreenGroup.png"];
    }
    else if ([currentDetails.group isEqualToString:@"Rose Group"]) {
        groupImage.image = [UIImage imageNamed:@"RoseGroup.png"];
    }
    else if ([currentDetails.group isEqualToString:@"DarkBlue Group"]) {
        groupImage.image = [UIImage imageNamed:@"DBlueGroup.png"];
    }
    else if ([currentDetails.group isEqualToString:@"Violet Group"]) {
        groupImage.image = [UIImage imageNamed:@"VioletGroup.png"];
    }
    else if (currentDetails.group == nil) {
        groupImage.hidden = YES;
    }


    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    TaskDetailViewController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"taskDetailViewController"];
    nav.selectedDetails = [mailData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:nav animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 103;
}

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion
{
    
    Details *currentDetails = (Details *)[mailData objectAtIndex:[self.mailTableView indexPathForCell:cell].row];
    if (!(self.statusSegment.selectedSegmentIndex == 0)) {
            [self resetTaskList];
    }
    else if (!(self.statusSegment.selectedSegmentIndex == 0)) {
            [self resetTaskList];
    }
    else{
        
        //Delete
        if (index == 0){
            
            if (![currentDetails.status isEqualToString:@"Closed"]) {
                [[Utilities sharedInstance] showAlert:currentDetails.status withMessage:@"You should need to close the task, before delete" withTarget:self];
            }
            else{
                [CoreDataHandler deleteFormWithPredicate:[self.mailTableView indexPathForCell:cell].row];
                // Remove device from table view
                [allMailData removeObjectAtIndex:[self.mailTableView indexPathForCell:cell].row];
                [self.mailTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[self.mailTableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
            }
            
        }
        //Close
        else if (index == 1){
            
            NSInteger indexValue = allMailData.count - [self.mailTableView indexPathForCell:cell].row - 1;
            
            [CoreDataHandler updateTaskToClose:[[allMailData valueForKey:kTaskNumber] objectAtIndex:[self.mailTableView indexPathForCell:cell].row] indexValue:indexValue];
            //        allMailData = [[NSMutableArray alloc] initWithArray:[CoreDataHandler fetchFormWithPredicate:nil]];
            //        allMailData = [[[allMailData reverseObjectEnumerator] allObjects] mutableCopy];
            [self setTableView];
            
            [self.mailTableView reloadData];
        }
        //Pickup
        else if (index == 2){
            
            NSInteger indexValue = allMailData.count - [self.mailTableView indexPathForCell:cell].row - 1;
            [CoreDataHandler updateTaskToOpen:[[allMailData valueForKey:kTaskNumber] objectAtIndex:[self.mailTableView indexPathForCell:cell].row] indexValue:indexValue];
            [self setTableView];
            [self.mailTableView reloadData];
            
        }
        //Move
        else if (index == 3){
            NSInteger indexValue = allMailData.count - [self.mailTableView indexPathForCell:cell].row - 1;
            [CoreDataHandler updateTaskToHold:[[allMailData valueForKey:kTaskNumber] objectAtIndex:[self.mailTableView indexPathForCell:cell].row] indexValue:indexValue];
            [self setTableView];
            [self.mailTableView reloadData];
        }

        
    }
    return YES;
}


- (NSString *)getMessageTime:(NSString *)messageTime
{
    NSDate *messageDate = [DateConverter convertDateString:messageTime FromFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval timeDiff = [[NSDate date] timeIntervalSinceDate:messageDate];
    NSString *formatDate;
    
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:messageDate];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    
    
    if (timeDiff<ONE_MIN) {
        int formatDiff = (int)timeDiff;
        formatDate = formatDiff==1 ? [NSString stringWithFormat:@"1 sec ago"]:[NSString stringWithFormat:@"%i secs ago", formatDiff];
    }
    else if (timeDiff<ONE_HR) {
        int formatDiff = (int)timeDiff/(ONE_MIN);
        formatDate = formatDiff==1 ? [NSString stringWithFormat:@"1 min ago"]:[NSString stringWithFormat:@"%i mins ago", formatDiff];
    }
    else if([today day] == [otherDay day] &&
            [today month] == [otherDay month] &&
            [today year] == [otherDay year] &&
            [today era] == [otherDay era]) {
        //do stuff
        formatDate = [DateConverter convertDate:messageDate ToFormat:@"hh:mm a"];
    }
    else {
        formatDate = [DateConverter convertDate:messageDate ToFormat:@"MMM d"];
    }
    return formatDate;
}

#pragma mark - Searchbar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    mailData = nil;
    self.mailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mailTableView reloadData];
    
    searchBar.text = @"";
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"formDescription contains[cd] %@",searchText];
    self.mailTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    mailData = prevMailData;
    mailData = [mailData filteredArrayUsingPredicate:predicate];
    
    [self.mailTableView reloadData];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [searchBar setShowsCancelButton:NO animated:YES];
    [self resetTaskList];
    
}

- (void)resetTaskList{
    
    self.prioritySegment.selectedSegmentIndex = 0;
    self.statusSegment.selectedSegmentIndex = 0;
    
    mailData = allMailData;
    if (mailData.count==0) {
        self.mailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.mailTableView reloadData];
    }
    else {
        self.mailTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.mailTableView reloadData];
        [self.mailTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }

}

#pragma mark - IBActions

- (void)filter:(NSString *)filterProperty UsingValue:(NSString *)filterValue
{
    mailData = allMailData;
    if (filterValue!=nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K matches %@",filterProperty,filterValue];
        mailData = [mailData filteredArrayUsingPredicate:predicate];
    }
    prevMailData = mailData;
    
    if (![self.mailSearchBar.text isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"formDescription contains[cd] %@",self.mailSearchBar.text];
        mailData = [mailData filteredArrayUsingPredicate:predicate];
    }
    
    if (mailData.count==0) {
        self.mailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.mailTableView reloadData];
    }
    else {
        self.mailTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.mailTableView reloadData];
        [self.mailTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
}
- (IBAction)filterStatus:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self filter:@"status" UsingValue:nil];
            [self setNavigationBar];
            break;
        case 1:
            [self filter:@"status" UsingValue:@"Open"];
            [self resetNavigationBar];
            break;
        case 2:
            [self filter:@"status" UsingValue:@"Closed"];
            [self resetNavigationBar];
            break;
        case 3:
            [self filter:@"status" UsingValue:@"On Hold"];
            [self resetNavigationBar];
            break;
            
        default:
            break;
    }
}
- (IBAction)filterPriority:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self filter:@"priority" UsingValue:nil];
            [self setNavigationBar];
            break;
        case 1:
            [self filter:@"priority" UsingValue:@"Low"];
            [self resetNavigationBar];
            break;
        case 2:
            [self filter:@"priority" UsingValue:@"Medium"];
            [self resetNavigationBar];
            break;
        case 3:
            [self filter:@"priority" UsingValue:@"High"];
            [self resetNavigationBar];
            break;
            
        default:
            break;
    }
}

#pragma mark-Local Notification

-(void)setLocalNotification{
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    for (Details *currentDetails in mailData) {
        
        if (!(currentDetails.reminderContent == nil)) {
            NSDate *todayDate = [NSDate date];
            NSDateFormatter *tdate = [[NSDateFormatter alloc] init];
            [tdate setDateFormat:@"dd-MM-yyy"];
            NSString *todayDateString = [tdate stringFromDate:todayDate];
            NSString *dateForNotification = [NSString stringWithFormat:@"%@ %@",todayDateString,currentDetails.reminderContent];
            NSDate *reminderTimeDate = [DateConverter convertDateString:dateForNotification FromFormat:@"dd-MM-yyyy hh:mm a"];
            NSTimeInterval reminderTime = [reminderTimeDate timeIntervalSinceDate:[NSDate date]];
            
            if(reminderTime > 0)
            {
                UILocalNotification *notification = [[UILocalNotification alloc]init];
                [notification setAlertBody:currentDetails.taskName];
                [notification setFireDate:[NSDate dateWithTimeIntervalSinceNow:reminderTime]];
                [notification setTimeZone:[NSTimeZone  defaultTimeZone]];
                [localNotificationList addObject:notification];
            }

        }
        
    }
    
    [[UIApplication sharedApplication] setScheduledLocalNotifications:localNotificationList];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
