//
//  Member.m
//  Team
//
//  Created by ChoJaehyun on 2015. 10. 3..
//  Copyright (c) 2015년 Classting. All rights reserved.
//

#import "Member.h"
#import "Entity.h"
#import "DataCenter.h"

@interface Member ()
@property (nonatomic, retain) UIImage *profileImage;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *history;
@property (nonatomic, assign) CGFloat average;
@end

@implementation Member

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.profileImage forKey:@"profileImage"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.history forKey:@"history"];
    [encoder encodeFloat:self.average forKey:@"average"];
}
- (id)initWithCoder:(NSCoder *)decoder {
    [self setProfileImage:[decoder decodeObjectForKey:@"profileImage"]];
    [self setName:[decoder decodeObjectForKey:@"name"]];
    [self setHistory:[decoder decodeObjectForKey:@"history"]];
    [self setAverage:[decoder decodeFloatForKey:@"average"]];
    return self;
}

+(Member *)createMember:(NSString *)name
{
    Member *member = [[Member alloc] init];
    [member setName:name];
    return member;
}
-(id)init
{
    self = [super init];
    [self setHistory:[NSMutableArray array]];
    return self;
}
-(void)addValue:(CGFloat)value withDate:(NSDate *)date
{
    Entity *entity = [Entity getEntityWIthValue:value withDate:date];
    [self.history addObject:entity];
    [self updateAverage];
    
    NSMutableArray *members = [DataCenter loadMembers];
    [DataCenter updateMember:members];
}

-(void)removeObjectAtIndex:(NSInteger)index
{
    if(index < self.history.count) {
        [self.history removeObjectAtIndex:index];
    }
    [self updateAverage];
    NSMutableArray *members = [DataCenter loadMembers];
    [DataCenter updateMember:members];
}

-(void)updateAverage
{
    CGFloat sum = 0;
    for (Entity *entity in self.history) {
        sum += [entity getValue];
    }
    [self setAverage:(sum/self.history.count)];
}

-(CGFloat)getAverage
{
    return _average;
}
-(NSString *)getName
{
    return _name;
}
-(NSMutableArray *)getHistory
{
    return _history;
}

-(void)setProfileImage:(UIImage *)image
{
    _profileImage = image;
}
-(UIImage *)getProfileImage
{
    if(self.profileImage) {
        return _profileImage;
    } else {
        return [UIImage imageNamed:@"user_profile"];
    }
}


@end
