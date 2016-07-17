//
//  TeamTests.m
//  TeamTests
//
//  Created by ChoJaehyun on 2015. 10. 2..
//  Copyright (c) 2015년 Classting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Member.h"
#import "Group.h"

@interface TeamTests : XCTestCase
{
    //input
    NSInteger numOfIteration;
    NSInteger numOfGroup;
    NSMutableArray *entitiies;
    NSMutableArray *groups;

    //result
    CGFloat mean;
    
    //dynamic temp
    CGFloat minimumTotalVariance;
}
@end


// n * g 의 복잡도
@implementation TeamTests

-(NSMutableArray *)getTempMembers
{
    NSMutableArray *members = [NSMutableArray array];
    for (int i = 0; i < 1000; i ++) {
        Member *member = [Member createMember:@"tester"];
        [members addObject:member];
        [member addValue:(arc4random()%200)+1 withDate:nil];
    }
    return members;
}

- (void)setUp {
    [super setUp];
    
    numOfIteration = 4;
    numOfGroup = 4;
    
    entitiies = [NSMutableArray array];
    {
        Member *member = [Member createMember:@"조재현"];
        [member addValue:115 withDate:nil];
        [entitiies addObject:member];
    }
    {
        Member *member = [Member createMember:@"조병훈"];
        [member addValue:123 withDate:nil];
        [entitiies addObject:member];
    }
    {
        Member *member = [Member createMember:@"이준헌"];
        [member addValue:94 withDate:nil];
        [entitiies addObject:member];
    }
    {
        Member *member = [Member createMember:@"권새빛나"];
        [member addValue:79 withDate:nil];
        [entitiies addObject:member];
    }
    {
        Member *member = [Member createMember:@"유재상"];
        [member addValue:94 withDate:nil];
        [entitiies addObject:member];
    }
    {
        Member *member = [Member createMember:@"윤요한"];
        [member addValue:97 withDate:nil];
        [entitiies addObject:member];
    }
    {
        Member *member = [Member createMember:@"최다운"];
        [member addValue:109 withDate:nil];
        [entitiies addObject:member];
    }
    {
        Member *member = [Member createMember:@"이재영"];
        [member addValue:60 withDate:nil];
        [entitiies addObject:member];
    }

    mean = 0;
    for (Member *entity in entitiies) {
        mean += [entity getAverage];
    }
    mean = mean/entitiies.count;
    
    groups = [NSMutableArray array];
    for (int i = 0; i<numOfGroup; i++) {
        [groups addObject:[[Group alloc] init]];
    }
}
- (void)tearDown {
    [super tearDown];
}

-(void)showResult
{
    for (Group *group in groups) {
        NSLog(@"\n[%@팀] (%@)\n%@\n",@([groups indexOfObject:group]+1),@([group getTotalValue]),[group getNames]);
    }
}

- (void)testExample {
    
    entitiies = [self getSortedEntities:entitiies];
    [self initializingGroups:groups withEntities:entitiies];
    
    for (NSInteger count = 0; count < numOfIteration; count ++) {
        for (NSInteger i =0; i<numOfGroup; i++) {
            [self iterationGroups:groups masterIndex:i];
        }
        
    }

    [self showResult];
}

-(NSMutableArray *)getSortedEntities:(NSMutableArray *)unsortedEntities
{
    NSArray *array = [entitiies sortedArrayUsingComparator:^NSComparisonResult(Member *obj1, Member *obj2) {
        return ([obj1 getAverage] < [obj2 getAverage]);
    }];
    NSMutableArray *result = [NSMutableArray array];
    for (Member *entity in array) {
        [result addObject:entity];
    }
    return result;
}
-(void)initializingGroups:(NSMutableArray *)entityGroups withEntities:(NSMutableArray *)sortedEntities
{
    for (NSInteger i = 0; i < sortedEntities.count; i++) {
        Member *entity = [sortedEntities objectAtIndex:i];
        NSInteger groupIndex = i%entityGroups.count;
        Group *group = [entityGroups objectAtIndex:groupIndex];
        [group addMember:entity];
    }
}

-(void)iterationGroups:(NSMutableArray *)entityGroups masterIndex:(NSInteger)index
{
    Group *masterGroup = [entityGroups objectAtIndex:index];
    
    for (Group *targetGroup in entityGroups) {
        if([masterGroup isEqual:targetGroup]) {
            continue;
        }
        
        Member *masterEntity = [masterGroup getRandomMember];
        CGFloat baseValue = [masterGroup getTotalValue] - [masterEntity getAverage];
        
        CGFloat groupAverage = ([masterGroup getTotalValue] + [targetGroup getTotalValue])/2;
        CGFloat minDiff = fabs(groupAverage - [masterGroup getTotalValue]);
        Member *replacement = nil;
        
        for (Member *targetEntity in [targetGroup getMembers] ) {
            
            CGFloat newValue = baseValue + [targetEntity getAverage];
            CGFloat newDiff = fabs(groupAverage - newValue);
            if(minDiff > newDiff) {
                replacement = targetEntity;
                minDiff = newDiff;
            }
        }
        
        if(replacement) {
            [self changeSourceGroup:masterGroup sourceEntity:masterEntity destinationGroup:targetGroup destinationEntity:replacement];
        }
    }
}


-(void)changeSourceGroup:(Group *)sGroup sourceEntity:(Member *)sEntity destinationGroup:(Group *)dGroup destinationEntity:(Member *)dEntity
{
    [sGroup addMember:dEntity];
    [dGroup addMember:sEntity];
    
    [sGroup deleteMember:sEntity];
    [dGroup deleteMember:dEntity];
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
