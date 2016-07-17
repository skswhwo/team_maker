//
//  MakeTeamViewController.m
//  Team
//
//  Created by ChoJaehyun on 2015. 10. 2..
//  Copyright (c) 2015년 Classting. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIButton *makeTeamButton;
@property (weak, nonatomic) IBOutlet UIButton *editTeamButton;
@property (weak, nonatomic) IBOutlet UIButton *changeTeamButton;

@end

@implementation MainViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.makeTeamButton.layer setCornerRadius:10];
    [self.editTeamButton.layer setCornerRadius:10];
    [self.changeTeamButton.layer setCornerRadius:10];
    
}

@end
