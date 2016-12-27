//
//  NavigationButtonItem.h
//  Task Leader
//
//  Created by Balajibabu S.G. on 25/12/16.
//  Copyright © 2016 Balajibabu S.G. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    Left,
    Right
} ButtonSide;

@interface NavigationButtonItem : UIBarButtonItem
@property (nonatomic, assign) float scale;
@property (nonatomic, assign) float padding;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) void (^finishBlock)();

- (id)initWithImage:(NSString *)imageName WithCompletionHandler:(void (^)(void))finishBlock;
- (id)getButtonWithSide:(ButtonSide)buttonSide;


@end
