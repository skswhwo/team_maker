//
//  ViewController.m
//  Team
//
//  Created by ChoJaehyun on 2015. 10. 2..
//  Copyright (c) 2015년 Classting. All rights reserved.
//

#import "EditTeamViewController.h"
#import "Member.h"
#import "DataCenter.h"

#import "ProfileViewController.h"

typedef enum
{
    TABLE_SECTION_MEMBER,
    TABLE_SECTION_ADD,

    TABLE_SECTION_COUNT
}TABLE_SECTION;
@interface EditTeamViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *members;
- (IBAction)rightButtonClicked:(id)sender;

@end

@implementation EditTeamViewController

-(void)dealloc
{
    [NotificationController removeChangeMenber:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMembers:[DataCenter loadMembers]];
    [NotificationController addChangeMember:self selector:@selector(memberChanged)];
    
    [self.navigationItem setTitle:@"팀 멤버 리스트"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tableView setEditing:NO animated:YES];
}
-(void)memberChanged
{
    [self setMembers:[DataCenter loadMembers]];
    [self.tableView reloadData];
}

-(void)addMember:(Member *)member
{
    [self.members addObject:member];
    [DataCenter updateMember:self.members];

    NSInteger row = [self.members indexOfObject:member];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(void)removeMember:(Member *)member
{
    NSInteger row = [self.members indexOfObject:member];

    [self.members removeObject:member];
    [DataCenter updateMember:self.members];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return TABLE_SECTION_COUNT;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == TABLE_SECTION_MEMBER) {
        return self.members.count;
    } else if (section == TABLE_SECTION_ADD) {
        return 1;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == TABLE_SECTION_MEMBER) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"memberCell"];
        Member *member = [self.members objectAtIndex:indexPath.row];
        [cell.imageView setImage:[member getProfileImage]];
        [cell.textLabel setText:[member getName]];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",@(ceil([member getAverage]))]];
        return cell;
    } else if (indexPath.section == TABLE_SECTION_ADD) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddMemberCell"];
        return cell;
    }
    return [UITableViewCell new];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showProfile"] ) {
        ProfileViewController *vc = (ProfileViewController *)[segue destinationViewController];
        [vc initializingWithMembers:self.members selectedMember:sender];
    }
}


#pragma mark - Editing
- (IBAction)rightButtonClicked:(id)sender {
    [self.tableView setEditing:(!self.tableView.isEditing) animated:YES];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeMember:[self.members objectAtIndex:indexPath.row]];
    } else if(editingStyle == UITableViewCellEditingStyleInsert) {
        [self showPointPopupView:[self.members objectAtIndex:indexPath.row] indexPath:indexPath];
    }
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.tableView.isEditing) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == TABLE_SECTION_MEMBER) {
        return YES;
    }
    return NO;
}

#pragma mark - Select
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == TABLE_SECTION_MEMBER) {
        Member *member = [self.members objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"showProfile" sender:member];
    } else if (indexPath.section == TABLE_SECTION_ADD) {
        [self showUserNamePopupView];
    }
}

#pragma mark - Reordering
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    Member *member = [self.members objectAtIndex:sourceIndexPath.row];
    [self.members removeObjectAtIndex:sourceIndexPath.row];
    [self.members insertObject:member atIndex:destinationIndexPath.row];
}
-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if(proposedDestinationIndexPath.section != TABLE_SECTION_MEMBER) {
        proposedDestinationIndexPath = [NSIndexPath indexPathForRow:(self.members.count-1) inSection:TABLE_SECTION_MEMBER];
    }
    return proposedDestinationIndexPath;
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == TABLE_SECTION_MEMBER) {
        return YES;
    }
    return NO;
}


#pragma mark - Add Member
-(void)showUserNamePopupView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"이름을 입력하세요" delegate:nil cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView setDidDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == [alertView cancelButtonIndex]) {
            NSLog(@"Cancelled");
        } else {
            NSString *name = [[alertView textFieldAtIndex:0] text];
            [self addMember:[Member createMember:name]];
        }
    }];
    [alertView setShouldEnableFirstOtherButtonBlock:^BOOL(UIAlertView *alertView) {
        return ([[[alertView textFieldAtIndex:0] text] length] > 0);
    }];
    [alertView show];
}
-(void)showPointPopupView:(Member *)member indexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"점수를 입력하세요" delegate:nil cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView setDidDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == [alertView cancelButtonIndex]) {
            NSLog(@"Cancelled");
        } else {
            NSString *point = [[alertView textFieldAtIndex:0] text];
            [member addValue:[point floatValue] withDate:[NSDate date]];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
    [alertView setShouldEnableFirstOtherButtonBlock:^BOOL(UIAlertView *alertView) {
        return ([[[alertView textFieldAtIndex:0] text] length] > 0);
    }];
    [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [alertView show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
