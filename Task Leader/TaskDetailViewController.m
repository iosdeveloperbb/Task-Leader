//
//  TaskDetailViewController.m
//  Task Leader
//
//  Created by Balajibabu S.G. on 27/12/16.
//  Copyright © 2016 Balajibabu S.G. All rights reserved.
//

#import "TaskDetailViewController.h"

@interface TaskDetailViewController ()

@end

@implementation TaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadMessageView];
}

- (void)loadMessageView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationItem.title = @"Task Description";
        self.navigationController.navigationBar.tintColor = [[Utilities sharedInstance] themeColor];

        self.contactName.text = self.selectedDetails.contactName;
        self.status.text = self.selectedDetails.status;
        self.messageTime.text = [DateConverter convertDateString:self.selectedDetails.messageTime FromFormat:@"yyyy-MM-dd HH:mm:ss" ToFormat:@"MMM dd hh:mm a"];
        self.formDescription.text = self.selectedDetails.formDescription;
        self.taskNumber.text = [NSString stringWithFormat:@"#%@",self.selectedDetails.taskNumber];
    });
    
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
