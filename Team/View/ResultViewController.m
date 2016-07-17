//
//  ResultViewController.m
//  Team
//
//  Created by ChoJaehyun on 2015. 10. 3..
//  Copyright (c) 2015년 Classting. All rights reserved.
//

#import "ResultViewController.h"
#import "Group.h"
#import "Member.h"
#import "TeamMaker.h"

@interface ResultViewController ()
<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;

@property (strong, nonatomic) NSMutableArray *selectedMembers;
@property (nonatomic, strong) NSMutableArray *groups;
@property (assign, nonatomic) NSInteger numOfGroup;
@end

@implementation ResultViewController

-(void)dealloc
{
    NSLog(@"dealloc result view");
}
-(void)initializingWithSelectedMembers:(NSMutableArray *)members withNumberOfGroup:(NSInteger)num
{
    [self setSelectedMembers:members];
    [self setNumOfGroup:num];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(createTeam) withObject:nil afterDelay:1];
}
-(void)createTeam
{
    TeamMaker *teamMaker = [[TeamMaker alloc] initWithMembers:self.selectedMembers];
    [teamMaker setNumOfGroup:self.numOfGroup];
    NSMutableArray *result = [teamMaker execute];
    [self setGroups:result];
    [self.tableView reloadData];
    
    [self.loadingView setHidden:YES];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:nil];
}




#pragma mark - Table
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Group *group = [self.groups objectAtIndex:section];
    return [group getMembers].count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Group *group = [self.groups objectAtIndex:section];
    NSString *header = [NSString stringWithFormat:@"%@팀 (총점 = %@)",@(section+1),@(ceil([group getTotalValue]))];
    return header;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"memberCell"];
    
    Group *group = [self.groups objectAtIndex:indexPath.section];
    Member *member = [[group getMembers] objectAtIndex:indexPath.row];
    [cell.imageView setImage:[member getProfileImage]];
    [cell.textLabel setText:[member getName]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",@(ceil([member getAverage]))]];
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
