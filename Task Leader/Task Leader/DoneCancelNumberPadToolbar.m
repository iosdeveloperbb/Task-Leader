//
//  DoneCancelNumberPadToolbar.m
//
//  Created by Timothy Broder on 8/17/12.
//
//

#import "DoneCancelNumberPadToolbar.h"

@implementation DoneCancelNumberPadToolbar

@synthesize delegate;

- (id) initWithTextField:(UITextField *)aTextField withNextTextField:(UITextField *)aNextTextField
{
    nextTextField = aNextTextField;
    return [self initWithTextField:aTextField withKeyboardType:UIKeyboardTypeNumberPad];
}

- (id) initWithTextField:(UITextField *)aTextField withKeyboardType:(int)keyboardType
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 50)];
    if (self) {
        textField = aTextField;
        [textField setKeyboardType:keyboardType];
        self.barStyle = UIBarStyleDefault;
        self.items = [NSArray arrayWithObjects:
                      [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                   target:nil action:nil],
                      [[UIBarButtonItem alloc]initWithTitle:@"Next"
                                                      style:UIBarButtonItemStyleDone
                                                     target:self
                                                     action:@selector(doneWithNumberPad)],
                      nil];
        [self sizeToFit];
        
    }
    return self;
}

- (id) initWithTextView:(UITextView *)aTextView withKeyboardType:(int)keyboardType
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 50)];
    if (self) {
        textView = aTextView;
        [textView setKeyboardType:keyboardType];
        self.barStyle = UIBarStyleDefault;
        self.items = [NSArray arrayWithObjects:
                      [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                   target:nil action:nil],
                      [[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                      style:UIBarButtonItemStyleDone
                                                     target:self
                                                     action:@selector(doneWithNumberPad)],
                      nil];
        [self sizeToFit];
        
    }
    return self;

}

-(void)cancelNumberPad
{
    [textField resignFirstResponder];
    textField.text = @"";
//    [self.delegate doneCancelNumberPadToolbarDelegate:self didClickCancel:textField];
}

-(void)doneWithNumberPad
{
    [nextTextField becomeFirstResponder];
    [textView resignFirstResponder];
//    [self.delegate doneCancelNumberPadToolbarDelegate:self didClickDone:textField];
}
@end