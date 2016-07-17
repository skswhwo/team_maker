//
//  TeamMaker.h
//  Team
//
//  Created by ChoJaehyun on 2015. 10. 2..
//  Copyright (c) 2015년 Classting. All rights reserved.
//

@interface TeamMaker : NSObject

-(id)initWithMembers:(NSMutableArray *)members;

@property (nonatomic, assign) NSInteger numOfIteration;
@property (nonatomic, assign) NSInteger numOfGroup;

-(NSMutableArray *)execute;

@end
