//
//  AboutViewController.m
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/21.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *titlab = [[UILabel alloc]init];
    titlab.text = @"版本";
    titlab.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlab;
    CGRect statusRect=[[UIApplication sharedApplication] statusBarFrame];
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WSCREEN, self.navigationController.navigationBar.frame.size.height + statusRect.size.height)];
    headview.backgroundColor = ColorWithRGB(74, 77, 108);
    [self.view addSubview:headview];
    [self setupUI];
}

-(void)setupUI{
    UIImageView *logoimg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"syslogo"]];
    [self.view addSubview:logoimg];
    [logoimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(150.0/375.0*WSCREEN);
        make.height.mas_equalTo(logoimg.mas_width);
        make.top.mas_equalTo(200.0/667.0*HSCREEN);
    }];
    
    UILabel *namelab = [[UILabel alloc]init];
    namelab.font = [UIFont systemFontOfSize:22.0/375.0*WSCREEN];
    namelab.text = @"For SYS";
    [self.view addSubview:namelab];
    [namelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(logoimg.mas_bottom).offset(30.0/667.0*HSCREEN);
    }];
    
    UILabel *mufenglab = [[UILabel alloc]init];
    mufenglab.textColor = ColorWithRGB(74, 77, 108);
    mufenglab.font = [UIFont systemFontOfSize:20.0/375.0*WSCREEN];
    mufenglab.text = @"木风随行";
    [self.view addSubview:mufenglab];
    [mufenglab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(namelab.mas_bottom).offset(30.0/667.0*HSCREEN);
    }];
    
    UILabel *version = [[UILabel alloc]init];
    version.font = [UIFont systemFontOfSize:14.0/375.0*WSCREEN];
    version.text = [NSString stringWithFormat:@"版本 V:%@",[ShareTools getVersionNum]];
    [self.view addSubview:version];
    [version mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-120.0/667.0*HSCREEN);
    }];
    
    UILabel *qqgroup = [[UILabel alloc]init];
    qqgroup.font = [UIFont systemFontOfSize:14.0/375.0*WSCREEN];
    qqgroup.text = @"QQ群: 966191229";
    [self.view addSubview:qqgroup];
    [qqgroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(version.mas_bottom).offset(20.0/667.0*HSCREEN);
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
