//
//  TeamMaker.m
//  Team
//
//  Created by ChoJaehyun on 2015. 10. 2..
//  Copyright (c) 2015년 Classting. All rights reserved.
//

#import "TeamMaker.h"
#import "Member.h"
#import "Group.h"

@interface TeamMaker ()

@property (nonatomic, retain) NSMutableArray *members;
@property (nonatomic, retain) NSMutableArray *groups;

@end

@implementation TeamMaker

-(id)init
{
    return [self initWithMembers:[NSMutableArray array]];
}
-(id)initWithMembers:(NSMutableArray *)members
{
    self = [super init];
    
    [self setGroups:[NSMutableArray array]];
    [self setMembers:members];
    [self setNumOfIteration:5];
    [self setNumOfGroup:2];
    
    return self;
}



-(NSMutableArray *)execute
{
    [self.groups removeAllObjects];
    for (int i = 0; i<self.numOfGroup; i++) {
        [self.groups addObject:[[Group alloc] init]];
    }
    
    [self setMembers:[self getSortedMembers:self.members]];
    [self initializingGroups:self.groups withMembers:self.members];
    
    for (NSInteger count = 0; count < self.numOfIteration; count ++) {
        for (NSInteger i =0; i<self.numOfGroup; i++) {
            [self iterationGroups:self.groups masterIndex:i];
        }
    }
    [self showResult:self.groups];
    return self.groups;
}


-(NSMutableArray *)getSortedMembers:(NSMutableArray *)unsortedMembers
{
    NSArray *array = [unsortedMembers sortedArrayUsingComparator:^NSComparisonResult(Member *obj1, Member *obj2) {
        return ([obj1 getAverage] < [obj2 getAverage]);
    }];
    NSMutableArray *result = [NSMutableArray array];
    for (Member *entity in array) {
        [result addObject:entity];
    }
    return result;
}
-(void)initializingGroups:(NSMutableArray *)groups withMembers:(NSMutableArray *)sortedMembers
{
    for (NSInteger i = 0; i < sortedMembers.count; i++) {
        Member *member = [sortedMembers objectAtIndex:i];
        NSInteger groupIndex = i%groups.count;
        Group *group = [groups objectAtIndex:groupIndex];
        [group addMember:member];
    }
}

-(void)iterationGroups:(NSMutableArray *)groups masterIndex:(NSInteger)index
{
    Group *masterGroup = [groups objectAtIndex:index];
    
    for (Group *targetGroup in groups) {
        if([masterGroup isEqual:targetGroup]) {
            continue;
        }
        
        Member *masterMember = [masterGroup getRandomMember];
        CGFloat baseValue = [masterGroup getTotalValue] - [masterMember getAverage];
        
        CGFloat groupAverage = ([masterGroup getTotalValue] + [targetGroup getTotalValue])/2;
        CGFloat minDiff = fabs(groupAverage - [masterGroup getTotalValue]);
        Member *replacement = nil;
        
        for (Member *targetMember in [targetGroup getMembers] ) {
            
            CGFloat newValue = baseValue + [targetMember getAverage];
            CGFloat newDiff = fabs(groupAverage - newValue);
            if(minDiff >= newDiff) {
                replacement = targetMember;
                minDiff = newDiff;
            }
        }
        
        if(replacement) {
            [self changeSourceGroup:masterGroup sourceMember:masterMember destinationGroup:targetGroup destinationMember:replacement];
        }
    }
}


-(void)changeSourceGroup:(Group *)sGroup sourceMember:(Member *)sMember destinationGroup:(Group *)dGroup destinationMember:(Member *)dMemeber
{
    [sGroup addMember:dMemeber];
    [dGroup addMember:sMember];
    
    [sGroup deleteMember:sMember];
    [dGroup deleteMember:dMemeber];
}



-(void)showResult:(NSMutableArray *)groups
{
    for (Group *group in groups) {
        NSLog(@"\n[%@팀] (%@)\n%@\n",@([groups indexOfObject:group]+1),@([group getTotalValue]),[group getNames]);
    }
}


@end
