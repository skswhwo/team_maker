//
//  Member.h
//  Team
//
//  Created by ChoJaehyun on 2015. 10. 3..
//  Copyright (c) 2015년 Classting. All rights reserved.
//

@interface Member : NSObject

@property (nonatomic, assign) BOOL isSelected;

+(Member *)createMember:(NSString *)name;

- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;

-(void)addValue:(CGFloat)value withDate:(NSDate *)date;
-(void)removeObjectAtIndex:(NSInteger)index;

-(CGFloat)getAverage;
-(NSString *)getName;
-(NSMutableArray *)getHistory;

-(UIImage *)getProfileImage;
-(void)setProfileImage:(UIImage *)image;
@end
