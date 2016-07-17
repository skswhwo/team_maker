//
//  NotificationController.h
//  Team
//
//  Created by ChoJaehyun on 2015. 10. 5..
//  Copyright (c) 2015년 Classting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationController : NSObject

+(void)postChangeMember;


+(void)addChangeMember:(id)sender selector:(SEL)selector;
+(void)removeChangeMenber:(id)sender;

@end
