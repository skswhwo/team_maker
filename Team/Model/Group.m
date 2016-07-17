//
//  Group.m
//  Team
//
//  Created by ChoJaehyun on 2015. 10. 2..
//  Copyright (c) 2015년 Classting. All rights reserved.
//

#import "Group.h"
#import "Member.h"

@interface Group ()

@property (retain, nonatomic) NSMutableArray *members;
@property (assign, nonatomic) CGFloat totalValue;

@end


@implementation Group
-(id)init
{
    self = [super init];
    [self setMembers:[NSMutableArray array]];
    return self;
}

-(Member *)getRandomMember
{
    NSInteger randomIndex = arc4random() % self.members.count;
    return [self.members objectAtIndex:randomIndex];
}

-(void)addMember:(Member *)member
{
    [self.members addObject:member];
    self.totalValue = self.totalValue + [member getAverage];
}
-(void)deleteMember:(Member *)member
{
    if ([self.members indexOfObject:member] != NSNotFound) {
        [self.members removeObject:member];
        self.totalValue = self.totalValue - [member getAverage];
    }
}

-(NSMutableArray *)getMembers
{
    return _members;
}
-(CGFloat)getTotalValue
{
    return _totalValue;
}

-(NSString *)getNames
{
    NSMutableArray *names = [NSMutableArray array];
    for (Member *member in self.members) {
        [names addObject:[member getName]];
    }
    return [names componentsJoinedByString:@"\n"];
}


@end
