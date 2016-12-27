//
//  NavigationButtonItem.m
//  Task Leader
//
//  Created by Balajibabu S.G. on 25/12/16.
//  Copyright © 2016 Balajibabu S.G. All rights reserved.
//

#import "NavigationButtonItem.h"

@implementation NavigationButtonItem

- (id)initWithImage:(NSString *)imageName WithCompletionHandler:(void (^)(void))finishBlock
{
    self = [super init];
    self.imageName = imageName;
    self.scale = 1.0f;
    self.padding = 20.0f;
    self.finishBlock = finishBlock;
    return self;
}

- (id)getButtonWithSide:(ButtonSide)buttonSide
{
    UIImage *imageName = [UIImage imageNamed:self.imageName];
    UIButton* buttonName = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imageName.size.width*self.scale+self.padding, imageName.size.height*self.scale)];
    
    buttonName.imageEdgeInsets = buttonSide==Left ? UIEdgeInsetsMake(0, 0, 0, self.padding) : UIEdgeInsetsMake(0, self.padding, 0, 0);
    [buttonName addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonName setImage:imageName forState:UIControlStateNormal];
    
    [self setCustomView:buttonName];
    return self;
}

- (void)buttonPressed:(id)sender
{
    self.finishBlock();
}


@end
