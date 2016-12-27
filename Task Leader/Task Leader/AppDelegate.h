//
//  AppDelegate.h
//  Task Leader
//
//  Created by Balajibabu S.G. on 25/12/16.
//  Copyright © 2016 Balajibabu S.G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

