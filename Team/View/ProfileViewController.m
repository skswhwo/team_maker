//
//  ProfileViewController.m
//  Team
//
//  Created by ChoJaehyun on 2015. 10. 2..
//  Copyright (c) 2015년 Classting. All rights reserved.
//

#import "ProfileViewController.h"
#import "Member.h"
#import "Entity.h"
#import "DataCenter.h"

@interface ProfileViewController ()
<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *members;
@property (nonatomic, strong) Member *selectedMember;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBarButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

- (IBAction)profileButtonClicked:(id)sender;

- (IBAction)deleteButtonClicked:(id)sender;
- (IBAction)rightButtonClicked:(id)sender;

@end

@implementation ProfileViewController

-(void)initializingWithMembers:(NSMutableArray *)members selectedMember:(Member *)selectedMember
{
    [self setMembers:members];
    [self setSelectedMember:selectedMember];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.nameLabel setText:[self.selectedMember getName]];
    [self.deleteButton.layer setCornerRadius:(self.deleteButton.frame.size.height/2)];
    [self.profileImageView setImage:[self.selectedMember getProfileImage]];
    [self.profileImageView.layer setCornerRadius:self.profileImageView.frame.size.width/2];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tableView setEditing:NO animated:YES];
}

- (IBAction)profileButtonClicked:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"카메라",@"앨범에서 사진 선택", nil];
    [actionSheet showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex == buttonIndex ) {
        return;
    }
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"카메라"]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:nil];
     } else {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    CGRect rect = CGRectMake(0,0,75,75);
    UIGraphicsBeginImageContext( rect.size );
    [image drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(picture1);
    image=[UIImage imageWithData:imageData];
    
    
    [self.profileImageView setImage:image];

    [self.selectedMember setProfileImage:image];
    [DataCenter updateMember:self.members];
    [NotificationController postChangeMember];
}

#pragma mark - Table
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"기록";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.selectedMember getHistory].count + 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [self.selectedMember getHistory].count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"averageCell"];
        if(self.selectedMember.getHistory.count == 0) {
            [cell.textLabel setText:@"기록이 없습니다"];
            [cell.detailTextLabel setText:@""];
        } else{
            [cell.textLabel setText:@"평균"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",@(ceil([self.selectedMember getAverage]))]];
        }
        return cell;
    } else {
        Entity *entity = [[self.selectedMember getHistory] objectAtIndex:indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PointCell"];
        [cell.textLabel setText:[entity getDateStringWithFormatter:@"yyyy. MM. dd"]];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",@([entity getValue])]];
        return cell;
    }
}

#pragma mark - Tableview swip
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [self.selectedMember getHistory].count) {
        ;
    } else {
        [self.selectedMember removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [self.selectedMember getHistory].count) {
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [self.selectedMember getHistory].count) {
        return NO;
    } else {
        return YES;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deleteButtonClicked:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"삭제하시겠습니까?" delegate:nil cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    [alertView setDidDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == [alertView cancelButtonIndex]) {
        } else {
            [self.members removeObject:self.selectedMember];
            [DataCenter updateMember:self.members];
            [NotificationController postChangeMember];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [alertView show];
}

- (IBAction)rightButtonClicked:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"점수를 입력하세요" delegate:nil cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView setDidDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == [alertView cancelButtonIndex]) {
            NSLog(@"Cancelled");
        } else {
            NSString *point = [[alertView textFieldAtIndex:0] text];
            [self.selectedMember addValue:[point floatValue] withDate:[NSDate date]];
            [NotificationController postChangeMember];
            [self.tableView reloadData];
        }
    }];
    [alertView setShouldEnableFirstOtherButtonBlock:^BOOL(UIAlertView *alertView) {
        return ([[[alertView textFieldAtIndex:0] text] length] > 0);
    }];
    [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [alertView show];
}
@end
