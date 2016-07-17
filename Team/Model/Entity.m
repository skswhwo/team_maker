//
//  Entity.m
//  Team
//
//  Created by ChoJaehyun on 2015. 10. 3..
//  Copyright (c) 2015년 Classting. All rights reserved.
//

#import "Entity.h"

@interface Entity ()

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, assign) CGFloat value;

@end


@implementation Entity
- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeFloat:self.value forKey:@"value"];
}
- (id)initWithCoder:(NSCoder *)decoder {
    [self setDate:[decoder decodeObjectForKey:@"date"]];
    [self setValue:[decoder decodeFloatForKey:@"value"]];
    return self;
}


+(Entity *)getEntityWIthValue:(CGFloat)value withDate:(NSDate *)date
{
    Entity *entity = [[Entity alloc] init];
    [entity setValue:value];
    if(date) {
        [entity setDate:date];
    } else {
        [entity setDate:[NSDate date]];
    }
    return entity;
}

-(CGFloat)getValue
{
    return _value;
}
-(NSDate *)getDate
{
    return _date;
}
-(NSString *)getDateStringWithFormatter:(NSString *)formatterString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterString];
    NSString *yearString = [formatter stringFromDate:self.date];
    return yearString;
}
@end
