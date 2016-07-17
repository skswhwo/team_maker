//
//  Entity.h
//  Team
//
//  Created by ChoJaehyun on 2015. 10. 3..
//  Copyright (c) 2015년 Classting. All rights reserved.
//

@interface Entity : NSObject

+(Entity *)getEntityWIthValue:(CGFloat)value withDate:(NSDate *)date;

-(CGFloat)getValue;
-(NSDate *)getDate;
-(NSString *)getDateStringWithFormatter:(NSString *)formatterString;
@end
