//
//  Utilities.m
//  Task Leader
//
//  Created by Balajibabu S.G. on 25/12/16.
//  Copyright © 2016 Balajibabu S.G. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities  

+ (Utilities *)sharedInstance
{
    static Utilities *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[Utilities alloc] init];
    });
    return model;
}

- (void)showAlert:(NSString *)title withMessage:(NSString *)message withTarget:(id)objname
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [objname presentViewController:alert animated:YES completion:nil];
}

- (UIAlertController *)createAlertWithAction:(NSString *)title withMessage:(NSString *)message withCancelButton:(NSString *)cancel withTarget:(id)objname
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    if (cancel!=nil)
    {
        [alert addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
    }
    [objname presentViewController:alert animated:YES completion:nil];
    return alert;
}

+ (BOOL)isValidMail:(NSString*)emailid
{
    NSRange searchRange = NSMakeRange(0, emailid.length);
    NSRange foundRange = [emailid rangeOfString:@"^[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z]{2,6}$"
                                        options:(NSCaseInsensitiveSearch|NSRegularExpressionSearch) range:searchRange];
    if (foundRange.length)
        return NO;
    return YES;
}


-(UIColor *)themeColor
{
    return [UIColor colorWithRed:(234/255.0) green:(56/255.0) blue:(106/255.0) alpha:1.0];
}


@end
