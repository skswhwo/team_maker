//
//  Group.h
//  Team
//
//  Created by ChoJaehyun on 2015. 10. 2..
//  Copyright (c) 2015년 Classting. All rights reserved.
//

@class Member;

@interface Group : NSObject

-(NSMutableArray *)getMembers;
-(Member *)getRandomMember;
-(void)addMember:(Member *)member;
-(void)deleteMember:(Member *)member;

-(CGFloat)getTotalValue;
-(NSString *)getNames;


@end

