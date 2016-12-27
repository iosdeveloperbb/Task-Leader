//
//  Utilities.h
//  Task Leader
//
//  Created by Balajibabu S.G. on 25/12/16.
//  Copyright © 2016 Balajibabu S.G. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject
+ (Utilities *)sharedInstance;
- (void)showAlert:(NSString *)title withMessage:(NSString *)message withTarget:(id)objname;
- (UIAlertController *)createAlertWithAction:(NSString *)title withMessage:(NSString *)message withCancelButton:(NSString *)cancel withTarget:(id)objname;
+ (BOOL)isValidMail:(NSString*)emailid;
-(UIColor *)themeColor;
@end

