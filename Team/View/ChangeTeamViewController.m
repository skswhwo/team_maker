//
//  ChangeTeamViewController.m
//  Team
//
//  Created by ChoJaehyun on 2015. 11. 11..
//  Copyright © 2015년 Classting. All rights reserved.
//

#import "ChangeTeamViewController.h"

#import "DataCenter.h"
#import "Member.h"

#import "SendTeamViewController.h"

#define MODE_SELECT_ALL 11
#define MODE_DESELECT_ALL 22

@interface ChangeTeamViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightNavigationButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)rightButtonClicked:(id)sender;

- (IBAction)receiveButtonClicked:(id)sender;
- (IBAction)sendButtonClicked:(id)sender;

@property (strong, nonatomic) NSMutableArray *members;

@end

@implementation ChangeTeamViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMembers:[DataCenter loadMembers]];
    [self updateNavigationTitle];
}

-(void)updateNavigationTitle
{
    NSMutableArray *selectedArray = [self getSelectedMembers];
    if(selectedArray.count == 0) {
        [self.navigationItem setTitle:@"멤버를 선택하세요"];
    } else {
        [self.navigationItem setTitle:[NSString stringWithFormat:@"%@명 선택",@(selectedArray.count)]];
    }
    
    if (selectedArray.count == self.members.count) {
        [self.rightNavigationButton setTitle:@"선택해제"];
        [self.rightNavigationButton setTag:MODE_DESELECT_ALL];
    } else {
        [self.rightNavigationButton setTitle:@"전체선택"];
        [self.rightNavigationButton setTag:MODE_SELECT_ALL];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.members.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"memberCell"];
    
    Member *member = [self.members objectAtIndex:indexPath.row];
    [cell.imageView setImage:[member getProfileImage]];
    [cell.textLabel setText:[member getName]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",@(ceil([member getAverage]))]];
    
    if(member.isSelected) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Member *member = [self.members objectAtIndex:indexPath.row];
    [member setIsSelected:(!member.isSelected)];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self updateNavigationTitle];
}

-(NSMutableArray *)getSelectedMembers
{
    NSMutableArray *selectedMembers = [NSMutableArray array];
    for (Member *member in self.members) {
        if(member.isSelected) {
            [selectedMembers addObject:member];
        }
    }
    return selectedMembers;
}

#pragma mark - Add Member
- (IBAction)rightButtonClicked:(id)sender {
    
    BOOL isSelect = NO;
    if(self.rightNavigationButton.tag == MODE_SELECT_ALL) {
        isSelect = YES;
    }
    
    for (Member *member in self.members) {
        [member setIsSelected:isSelect];
    }
    
    [self updateNavigationTitle];
    [self.tableView reloadData];
}


- (IBAction)receiveButtonClicked:(id)sender {
}

- (IBAction)sendButtonClicked:(id)sender {
    
//    [self performSegueWithIdentifier:@"ResultViewController" sender:nil];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SendTeamViewController"] ) {
        SendTeamViewController *vc = (SendTeamViewController *)[segue destinationViewController];
        [vc setSelectedMembers:[self getSelectedMembers]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
