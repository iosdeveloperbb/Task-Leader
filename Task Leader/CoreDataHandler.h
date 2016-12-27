//
//  CoreDataHandler.h
//  Task Leader
//
//  Created by Balajibabu S.G. on 26/12/16.
//  Copyright © 2016 Balajibabu S.G. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "Details.h"
#import "Headers.h"

@interface CoreDataHandler : NSManagedObject

+ (NSManagedObjectContext *)managedObjectContext;
+ (void)saveDetails:(Details *)sentForm;
+ (NSArray *)fetchFormWithPredicate:(NSPredicate *)predicate;
+ (void)deleteFormWithPredicate:(NSInteger)indexPathValue;
+(void)updateTaskToClose:(NSString *)indexPathValue indexValue:(NSInteger)indexPath;
+(void)updateTaskToOpen:(NSString *)indexPathValue indexValue:(NSInteger)indexPath;
+(void)updateTaskToHold:(NSString *)taskNumber indexValue:(NSInteger)indexPath;

@end
