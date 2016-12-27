//
//  Details.h
//  Task Leader
//
//  Created by Balajibabu S.G. on 26/12/16.
//  Copyright © 2016 Balajibabu S.G. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Details : NSObject

@property (nonatomic, strong) NSString* taskNumber;//ticketNumber
@property (nonatomic, strong) NSString* contactName;
@property (nonatomic, strong) NSString* phone;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* formDescription;
@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) NSString* taskName;//productName
@property (nonatomic, strong) NSString* reminderContent;//ticketOwner
@property (nonatomic, strong) NSString* content;//accountName
@property (nonatomic, strong) NSString* dueDate;
@property (nonatomic, strong) NSString* priority;
@property (nonatomic, strong) NSString* group;//channel
@property (nonatomic, strong) NSString* classification;
@property (nonatomic, strong) NSString* messageTime;

@end
