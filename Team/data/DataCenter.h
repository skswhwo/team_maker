//
//  DataCenter.h
//  Team
//
//  Created by ChoJaehyun on 2015. 10. 3..
//  Copyright (c) 2015년 Classting. All rights reserved.
//


@interface DataCenter : NSObject

+(id)sharedInstance;
+(NSMutableArray *)loadMembers;
+(void)updateMember:(NSMutableArray *)members;

@end
