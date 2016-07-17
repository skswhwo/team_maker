//
//  DataCenter.m
//  Team
//
//  Created by ChoJaehyun on 2015. 10. 3..
//  Copyright (c) 2015년 Classting. All rights reserved.
//

#import "DataCenter.h"

#define MEMBER_KEY @"MEMBERS"

@interface DataCenter ()

@property (nonatomic, retain) NSMutableArray *members;

@end
@implementation DataCenter

static id _sharedInstance;
+(id)sharedInstance
{
    if(_sharedInstance == nil) {
        _sharedInstance = [[DataCenter alloc] init];
    }
    return _sharedInstance;
}

-(id)init
{
    self = [super init];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray *members = [NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:MEMBER_KEY]];
    NSMutableArray *results = [NSMutableArray array];
    for (id member in members) {
        [results addObject:member];
    }
    [self setMembers:results];
    
    return self;
}
+(NSMutableArray *)loadMembers
{
    DataCenter *shareInstance = [DataCenter sharedInstance];
    return shareInstance.members;
}
+(void)updateMember:(NSMutableArray *)members
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSKeyedArchiver archivedDataWithRootObject:members] forKey:MEMBER_KEY];
    [prefs synchronize];
}

@end
