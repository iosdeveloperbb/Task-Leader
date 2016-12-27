//
//  CoreDataHandler.m
//  Task Leader
//
//  Created by Balajibabu S.G. on 26/12/16.
//  Copyright © 2016 Balajibabu S.G. All rights reserved.
//

#import "CoreDataHandler.h"
#import "AppDelegate.h"

@implementation CoreDataHandler

+ (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(persistentContainer)])
    {
        context = [[delegate persistentContainer]viewContext];
    }
    
    return context;
}


+ (void)saveDetails:(Details *)sentForm
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kEntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskNumber = %@", sentForm.taskNumber];
    fetchRequest.predicate=predicate;
    NSManagedObject *updateObject = [[context executeFetchRequest:fetchRequest error:nil] lastObject];
    NSLog(@"%@", [updateObject valueForKey:kTaskNumber]);
    if([[updateObject valueForKey:kTaskNumber] isEqualToString:sentForm.taskNumber])
    {
        [self setManagedObject:updateObject WithForm:sentForm];
        [self saveToDatabase];
    }
    else
    {
        NSArray *dbDatas = [CoreDataHandler fetchFormWithPredicate:nil];
        if (dbDatas.count==0) {
            sentForm.taskNumber=@"100";
        }
        else {
            Details *lastDetail = [dbDatas lastObject];
            sentForm.taskNumber = [NSString stringWithFormat:@"%i",[lastDetail.taskNumber intValue]+1];
        }
        NSManagedObject *new = [NSEntityDescription insertNewObjectForEntityForName:kEntityName inManagedObjectContext:context];
        [self setManagedObject:new WithForm:sentForm];
        [self saveToDatabase];
    }
}


+ (NSArray *)fetchFormWithPredicate:(NSPredicate *)predicate
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kEntityName];
    
    if (predicate!=nil)
    {
        fetchRequest.predicate = predicate;
    }
    
    NSArray *allValues = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    //Storing in FoodItems
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    if (allValues.count>0)
    {
        for (NSManagedObject *object in allValues)
        {
            Details *newDetail = [[Details alloc] init];
            newDetail.contactName = [object valueForKey:kContactName];
            newDetail.email = [object valueForKey:kEmail];
            newDetail.formDescription = [object valueForKey:kFormDescription];
            newDetail.status = [object valueForKey:kStatus];
            newDetail.taskName = [object valueForKey:kTaskName];
            newDetail.reminderContent = [object valueForKey:kReminderContent];
            newDetail.taskNumber = [object valueForKey:kTaskNumber];
            newDetail.content = [object valueForKey:kContent];
            newDetail.dueDate = [object valueForKey:kDueDate];
            newDetail.priority = [object valueForKey:kPriority];
            newDetail.group = [object valueForKey:kGroup];
            newDetail.classification = [object valueForKey:kClassification];
            newDetail.messageTime = [object valueForKey:kMessageTime];
            newDetail.phone = [object valueForKey:kPhone];
            [modelArray addObject:newDetail];
        }
    }
    NSLog(@"Total datas: %lu", (unsigned long)allValues.count);
    
    return modelArray;
}

+ (void)deleteFormWithPredicate:(NSInteger)indexPathValue
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kEntityName];
    NSArray *allValues = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [context deleteObject:[allValues objectAtIndex:indexPathValue]];
    [self saveToDatabase];
}


+(void)updateTaskToClose:(NSString *)taskNumber indexValue:(NSInteger)indexPath{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kEntityName];
    NSManagedObject *updateObject = [[context executeFetchRequest:fetchRequest error:nil] objectAtIndex:indexPath];
    if(![[updateObject valueForKey:kStatus] isEqualToString:@"Closed"])
    {
        [updateObject setValue:@"Closed" forKey:kStatus];
        [context save:nil];
    }    
    [self saveToDatabase];
    
}

+(void)updateTaskToOpen:(NSString *)taskNumber indexValue:(NSInteger)indexPath{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kEntityName];
    NSManagedObject *updateObject = [[context executeFetchRequest:fetchRequest error:nil] objectAtIndex:indexPath];
    if(![[updateObject valueForKey:kStatus] isEqualToString:@"Open"])
    {
        [updateObject setValue:@"Open" forKey:kStatus];
        [context save:nil];
    }
    [self saveToDatabase];
    
}

+(void)updateTaskToHold:(NSString *)taskNumber indexValue:(NSInteger)indexPath{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kEntityName];
    NSManagedObject *updateObject = [[context executeFetchRequest:fetchRequest error:nil] objectAtIndex:indexPath];
    if(![[updateObject valueForKey:kStatus] isEqualToString:@"On Hold"])
    {
        [updateObject setValue:@"On Hold" forKey:kStatus];
        [context save:nil];
    }
    [self saveToDatabase];
    
}





+ (void)setManagedObject:(NSManagedObject *)manObject WithForm:(Details *)sentDetails
{
    [manObject setValue:sentDetails.contactName forKey:kContactName];
    [manObject setValue:sentDetails.email forKey:kEmail];
    [manObject setValue:sentDetails.formDescription forKey:kFormDescription];
    [manObject setValue:sentDetails.status forKey:kStatus];
    [manObject setValue:sentDetails.taskName forKey:kTaskName];
    [manObject setValue:sentDetails.reminderContent forKey:kReminderContent];
    [manObject setValue:sentDetails.taskNumber forKey:kTaskNumber];
    [manObject setValue:sentDetails.content forKey:kContent];
    [manObject setValue:sentDetails.dueDate forKey:kDueDate];
    [manObject setValue:sentDetails.priority forKey:kPriority];
    [manObject setValue:sentDetails.group forKey:kGroup];
    [manObject setValue:sentDetails.classification forKey:kClassification];
    [manObject setValue:sentDetails.messageTime forKey:kMessageTime];
    [manObject setValue:sentDetails.phone forKey:kPhone];
}

+(void)saveToDatabase
{
    // Save the object to persistent store
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}





@end
