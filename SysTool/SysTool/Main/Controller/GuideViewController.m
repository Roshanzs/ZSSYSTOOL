//
//  GuideViewController.m
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/22.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *titlab = [[UILabel alloc]init];
    titlab.text = @"新手引导";
    titlab.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlab;
    CGRect statusRect=[[UIApplication sharedApplication] statusBarFrame];
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WSCREEN, self.navigationController.navigationBar.frame.size.height + statusRect.size.height)];
    headview.backgroundColor = ColorWithRGB(74, 77, 108);
    [self.view addSubview:headview];
    [self setupUI];
}

-(void)setupUI{
    UIImageView *logoimg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guideImg"]];
    [self.view addSubview:logoimg];
    [logoimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.top.mas_equalTo(self.view);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
