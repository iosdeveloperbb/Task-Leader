//
//  AddTaskViewController.m
//  Task Leader
//
//  Created by Balajibabu S.G. on 26/12/16.
//  Copyright © 2016 Balajibabu S.G. All rights reserved.
//

#import "AddTaskViewController.h"


@interface AddTaskViewController (){
    UIDatePicker *datePicker, *timePicker;
    UIView *overLayView;
}

@end

@implementation AddTaskViewController

@synthesize currentDetails;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    currentDetails = [[Details alloc] init];
    self.groupColorLabel.clipsToBounds = YES;
    self.groupColorLabel.backgroundColor = [UIColor clearColor];
    self.groupColorLabel.layer.cornerRadius = 21.0f;
    
    [self loadInitialSettings];
    
    DoneCancelNumberPadToolbar *toolbar = [[DoneCancelNumberPadToolbar alloc] initWithTextField:self.phoneTextField withNextTextField:self.subjectTextField];
    
    self.phoneTextField.inputAccessoryView = toolbar;

    
}


- (void)setNavigationBar
{
    
    self.navigationItem.title = @"Add Task";
    
    NavigationButtonItem *leftArrow = [[NavigationButtonItem alloc] initWithImage:@"CloseX.png" WithCompletionHandler:^{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    leftArrow.scale = 0.4f;
    self.navigationItem.leftBarButtonItem = [leftArrow getButtonWithSide:Left];
    
    UIBarButtonItem *saveButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                  target:self
                                                  action:@selector(saveForm:)];
    saveButton.tintColor = [[Utilities sharedInstance] themeColor];
    self.navigationItem.rightBarButtonItem = saveButton;
    
}

- (void)setDoneButton
{
    UIBarButtonItem *doneButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(doneForm:)];
    doneButton.tintColor = [[Utilities sharedInstance] themeColor];
    self.navigationItem.rightBarButtonItem = doneButton;
}


- (void)saveForm:(id)sender
{
    if ([self.contactNameTextField.text isEqualToString:@""]) {
        [[Utilities sharedInstance] showAlert:@"Missing!" withMessage:@"You should fill the contact name" withTarget:self];
    }
    else if ([self.subjectTextField.text isEqualToString:@""]) {
        [[Utilities sharedInstance] showAlert:@"Missing!" withMessage:@"You should fill the subject name" withTarget:self];
    }
    else if ([self.groupTextField.text isEqualToString:@""]) {
        [[Utilities sharedInstance] showAlert:@"Missing!" withMessage:@"You should select the group to add" withTarget:self];
    }
    else if (self.emailTextField.text.length && [Utilities isValidMail:self.emailTextField.text]){
        [[Utilities sharedInstance] showAlert:@"Invalid Mail ID" withMessage:@"Please enter the valid Mail ID" withTarget:self];
    }
    else if (self.reminderTextField.text.length && !self.contentTextField.text.length){
        [[Utilities sharedInstance] showAlert:@"Content Missing" withMessage:@"Please enter the content to remind" withTarget:self];
    }
    else {
        currentDetails.contactName = self.contactNameTextField.text;
        currentDetails.email = self.emailTextField.text;
        currentDetails.phone = self.phoneTextField.text;
        currentDetails.formDescription = self.subjectTextField.text;
        currentDetails.status = [self getStatusText];
        currentDetails.taskName = self.taskNameTextField.text;
        currentDetails.content = self.contentTextField.text;
        currentDetails.dueDate = self.dueDateTextField.text;
        currentDetails.priority = [self getPriorityText];
        currentDetails.group = self.groupTextField.text;
        currentDetails.reminderContent = self.reminderTextField.text;
        currentDetails.classification = self.classificationTextField.text;
        currentDetails.messageTime = [DateConverter convertDate:[NSDate date] ToFormat:@"yyyy-MM-dd HH:mm:ss"];
        [CoreDataHandler saveDetails:currentDetails];
        [[Utilities sharedInstance] showAlert:@"Success" withMessage:@"You request submitted successfully" withTarget:self];
        [self setDoneButton];
    }
    [self resignAllResponder];
}


- (NSString *)getStatusText
{
    switch (self.statusSegmentControl.selectedSegmentIndex) {
        case 0:
            return @"Open";
            break;
        case 1:
            return @"Closed";
            break;
        case 2:
            return @"On Hold";
            break;
            
        default:
            return @"Open";
            break;
    }
}

- (NSString *)getPriorityText
{
    switch (self.prioritySegmentControl.selectedSegmentIndex) {
        case 0:
            return @"None";
            break;
        case 1:
            return @"Low";
            break;
        case 2:
            return @"Medium";
            break;
        case 3:
            return @"High";
            break;
            
        default:
            return @"Open";
            break;
    }
}


- (void)resignAllResponder
{
    for (UITextField *text in self.textFieldContentView.subviews) {
        if ([text isFirstResponder]) {
            [text resignFirstResponder];
        }
    }
}

- (void)doneForm:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadInitialSettings
{
    self.statusSegmentControl.selectedSegmentIndex = 0;
    self.prioritySegmentControl.selectedSegmentIndex = 0;
}


#pragma mark- TextField Delegate


-(void)resignResponders{
   
    [self.contactNameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.subjectTextField resignFirstResponder];
    [self.taskNameTextField resignFirstResponder];
    [self.reminderTextField resignFirstResponder];
    [self.contentTextField resignFirstResponder];
    [self.dueDateTextField resignFirstResponder];
    [self.groupTextField resignFirstResponder];
    [self.classificationTextField resignFirstResponder];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.groupTextField) {
        [self showAlertAction];
        [self resignResponders];
        return NO;
    }
    else if (textField == self.dueDateTextField){
        [self showDatePicker];
        [self resignResponders];
        return NO;
    }
    else if (textField == self.reminderTextField){
        [self showTimePicker];
        [self resignResponders];
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *charcter =[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    if ([textField isEqual:self.phoneTextField]) {
        if ([string isEqualToString:@""]) {
            return  YES;
        }
        else if (self.phoneTextField.text.length>=10)  {
            return NO;
        }
        else if ([string rangeOfCharacterFromSet:charcter].location!=NSNotFound)  {
            return NO;
        }
        else {
            return YES;
        }
    }
    else {
        return YES;
    }
}

#pragma mark- UIAlertAction

- (void)showAlertAction
{
    UIAlertAction *red = [UIAlertAction actionWithTitle:@"Red" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.groupTextField.text = @"Red Group";
        self.groupColorLabel.layer.cornerRadius = 21.0f;
        self.groupColorLabel.backgroundColor = [UIColor colorWithRed:(222/255.0) green:(53/255.0) blue:(47/255.0) alpha:1.0];
        
    }];
    
    UIAlertAction *green = [UIAlertAction actionWithTitle:@"Green" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.groupTextField.text = @"Green Group";
        self.groupColorLabel.backgroundColor = [UIColor colorWithRed:(46/255.0) green:(197/255.0) blue:(44/255.0) alpha:1.0];
    }];
    
    UIAlertAction *blue = [UIAlertAction actionWithTitle:@"Blue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.groupTextField.text = @"Blue Group";
        self.groupColorLabel.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(107/255.0) blue:(170/255.0) alpha:1.0];
    }];
    
    UIAlertAction *grey = [UIAlertAction actionWithTitle:@"Grey" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.groupTextField.text = @"Grey Group";
        self.groupColorLabel.backgroundColor = [UIColor colorWithRed:(33/255.0) green:(47/255.0) blue:(63/255.0) alpha:1.0];
    }];
    
    UIAlertAction *yellow = [UIAlertAction actionWithTitle:@"Yellow" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.groupTextField.text = @"Yellow Group";
        self.groupColorLabel.backgroundColor = [UIColor colorWithRed:(238/255.0) green:(138/255.0) blue:(18/255.0) alpha:1.0];
    }];
    
    UIAlertAction *darkgreen = [UIAlertAction actionWithTitle:@"Dark Green" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.groupTextField.text = @"DarkGreen Group";
        self.groupColorLabel.backgroundColor = [UIColor colorWithRed:(20/255.0) green:(49/255.0) blue:(14/255.0) alpha:1.0];
    }];
    
    UIAlertAction *rose = [UIAlertAction actionWithTitle:@"Rose" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.groupTextField.text = @"Rose Group";
        self.groupColorLabel.backgroundColor = [UIColor colorWithRed:(231/255.0) green:(78/255.0) blue:(128/255.0) alpha:1.0];
    }];
    
    UIAlertAction *darkblue = [UIAlertAction actionWithTitle:@"Dark Blue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.groupTextField.text = @"DarkBlue Group";
        self.groupColorLabel.backgroundColor = [UIColor colorWithRed:(33/255.0) green:(17/255.0) blue:(227/255.0) alpha:1.0];
    }];
    
    UIAlertAction *violet = [UIAlertAction actionWithTitle:@"Violet" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.groupTextField.text = @"Violet Group";
        self.groupColorLabel.backgroundColor = [UIColor colorWithRed:(122/255.0) green:(43/255.0) blue:(157/255.0) alpha:1.0];
    }];
    
    
    UIAlertController *groupAlert = [[Utilities sharedInstance] createAlertWithAction:@"Group" withMessage:@"Select a Group" withCancelButton:@"Cancel" withTarget:self];
    [groupAlert addAction:red];
    [groupAlert addAction:green];
    [groupAlert addAction:blue];
    [groupAlert addAction:grey];
    [groupAlert addAction:yellow];
    [groupAlert addAction:darkgreen];
    [groupAlert addAction:rose];
    [groupAlert addAction:darkblue];
    [groupAlert addAction:violet];
}

#pragma mark- Date Picker

-(void)showDatePicker{
    
    overLayView =[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    overLayView.backgroundColor = [UIColor colorWithRed:0.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:0.5];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.view addSubview:overLayView];
    [self.view bringSubviewToFront:overLayView];

    
    datePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 300)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.hidden = NO;
    datePicker.date = [NSDate date];
    datePicker.minimumDate = [NSDate date];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateChange:)];
    [overLayView addGestureRecognizer:tap];
    [overLayView addSubview:datePicker]; //this can set value of selected date to your label change according to your condition
}

-(void)dateSet{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dateChange:) object:nil];
    [self performSelector:@selector(dateChange:) withObject:nil afterDelay:2.0];
    
}

- (void)dateChange:(id)sender{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy"];
    self.dueDateTextField.text = [NSString stringWithFormat:@"%@",
                                  [df stringFromDate:datePicker.date]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [overLayView removeFromSuperview];
    [datePicker removeFromSuperview];
}


#pragma mark- Time Picker

-(void)showTimePicker{
    
    overLayView =[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    overLayView.backgroundColor = [UIColor colorWithRed:0.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:0.5];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.view addSubview:overLayView];
    [self.view bringSubviewToFront:overLayView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeChange:)];
    [overLayView addGestureRecognizer:tap];

    
    timePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 300)];
    timePicker.datePickerMode = UIDatePickerModeTime;
    timePicker.backgroundColor = [UIColor whiteColor];
    timePicker.hidden = NO;
    timePicker.date = [NSDate date];
    timePicker.minimumDate = [NSDate date];
    
    [overLayView addSubview:timePicker]; //this can set value of selected date to your label change according to your condition
}

-(void)timeSet{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeChange:) object:nil];
    [self performSelector:@selector(timeChange:) withObject:nil afterDelay:2.0];
    
}

- (void)timeChange:(id)sender{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"hh:mm a"];
    self.reminderTextField.text = [NSString stringWithFormat:@"%@",[df stringFromDate:timePicker.date]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [overLayView removeFromSuperview];
    [timePicker removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
