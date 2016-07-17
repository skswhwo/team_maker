//
//  ProfileViewController.h
//  Team
//
//  Created by ChoJaehyun on 2015. 10. 2..
//  Copyright (c) 2015년 Classting. All rights reserved.
//

@class Member;

@interface ProfileViewController : UIViewController

-(void)initializingWithMembers:(NSMutableArray *)members selectedMember:(Member *)selectedMember;

@end
