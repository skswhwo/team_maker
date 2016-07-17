//
//  NotificationController.m
//  Team
//
//  Created by ChoJaehyun on 2015. 10. 5..
//  Copyright (c) 2015년 Classting. All rights reserved.
//

#import "NotificationController.h"

#define TEAM_NOTIFICATION_MEMBERS @"local_notification_members"

@implementation NotificationController

+(void)postChangeMember
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TEAM_NOTIFICATION_MEMBERS object:nil];
}

+(void)addChangeMember:(id)sender selector:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] addObserver:sender selector:selector name:TEAM_NOTIFICATION_MEMBERS object:nil];
}

+(void)removeChangeMenber:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:sender name:TEAM_NOTIFICATION_MEMBERS object:nil];
}

@end
