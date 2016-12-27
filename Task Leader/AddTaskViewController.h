//
//  AddTaskViewController.h
//  Task Leader
//
//  Created by Balajibabu S.G. on 26/12/16.
//  Copyright © 2016 Balajibabu S.G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Headers.h"
#import "Details.h"
#import "CoreDataHandler.h"
#import <AssetsLibrary/AssetsLibrary.h>

typedef void (^ALAssetsLibraryWriteImageCompletionBlock)(NSURL *assetURL, NSError *error);


@interface AddTaskViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) Details* currentDetails;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *contactNameTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *emailTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *phoneTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *subjectTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *statusSegmentControl;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *taskNameTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *reminderTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *contentTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *dueDateTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *prioritySegmentControl;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *groupTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *classificationTextField;
@property (weak, nonatomic) IBOutlet UILabel *groupColorLabel;

@property (strong, nonatomic) IBOutlet UIView *textFieldContentView;
@end
