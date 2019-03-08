//
//  LiuliangNumViewController.m
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/16.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "LiuliangNumViewController.h"

@interface LiuliangNumViewController ()
@property(nonatomic,strong)NSString *titlelabStr;
@property(nonatomic,strong)UILabel *sizelab;
@property(nonatomic,strong)NSString *textfiledStr;
@property(nonatomic,strong)UITextField *textfiled;
@property(nonatomic,strong)UIButton *currBtn;
@end

@implementation LiuliangNumViewController

-(instancetype)initWithTitle:(NSString *)title WithNoticeStr:(NSString *)noticeStr{
    self = [super init];
    if (self) {
        self.titlelabStr = title;
        self.textfiledStr = noticeStr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect statusRect=[[UIApplication sharedApplication] statusBarFrame];
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WSCREEN, self.navigationController.navigationBar.frame.size.height + statusRect.size.height)];
    headview.backgroundColor = ColorWithRGB(74, 77, 108);
    [self.view addSubview:headview];
    
    self.view.backgroundColor = ColorWithRGB(222, 222, 222);
    UILabel *titlab = [[UILabel alloc]init];
    titlab.text = self.titlelabStr;
    titlab.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlab;
    
    UIBarButtonItem *sureBtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:(UIBarButtonItemStylePlain) target:self action:@selector(sureBtnClick)];
    self.navigationItem.rightBarButtonItem = sureBtn;
    [self setupUI];
}

-(void)sureBtnClick{
    if (self.textfiled.text == nil || self.textfiled.text.length <= 0) {
        [EasyTextView showErrorText:@"请输入流量数据!"];
        return;
    }
    if ([self.textfiled.text floatValue] < 0) {
        [EasyTextView showErrorText:@"流量数据不可为负!"];
        return;
    }
    BOOL issave = NO;
    BOOL isCurrLiuliang = NO;
    CGFloat textlong = 0;
    if (self.currBtn.tag == 408) {
        textlong = [self.textfiled.text floatValue]*1024*1024;
    }else{
        textlong = [self.textfiled.text floatValue]*1024*1024*1024;
    }
    if ([self.titlelabStr isEqualToString:@"套餐流量"]) {
        issave = [ShareTools SaveStateWithValue:[NSString stringWithFormat:@"%.2f",textlong] WithKey:TOTLENETDATE];
        isCurrLiuliang = YES;
    }else if([self.titlelabStr isEqualToString:@"本月已用流量"]){
        issave = [ShareTools SaveStateWithValue:[NSString stringWithFormat:@"%.2f",textlong] WithKey:HADUSENETDATA];
        isCurrLiuliang = [ShareTools SaveStateWithValue:[NSString stringWithFormat:@"%@",[[NetWorkInfoTool sharedManager] getWWANTotalFolwBytes]] WithKey:NETDATACLEAR];
    }else{
        issave = [ShareTools SaveStateWithValue:[NSString stringWithFormat:@"%.2f",textlong] WithKey:CURRDAYCANUSE];
        isCurrLiuliang = YES;
    }
    if (issave && isCurrLiuliang) {
        [EasyTextView showSuccessText:@"设置成功!"];
        [self performSelector:@selector(POPtoView) withObject:nil afterDelay:1.0];
    }else{
        [EasyTextView showErrorText:@"设置失败!"];
    }
}

-(void)POPtoView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_textfiled becomeFirstResponder];
}

-(void)setupUI{
    UIView *bgv = [[UIView alloc]init];
    bgv.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgv];
    [bgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(100.0/667.0*HSCREEN);
        make.height.mas_equalTo(60.0/667.0*HSCREEN);
    }];
    
    UILabel *titlelab = [[UILabel alloc]init];
    titlelab.text = self.titlelabStr;
    titlelab.font = [UIFont systemFontOfSize:14.0/375.0*WSCREEN];
    [self.view addSubview:titlelab];
    [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgv);
        make.left.mas_equalTo(bgv).offset(20.0/375.0*WSCREEN);
        make.width.mas_equalTo(100.0/375.0*WSCREEN);
    }];
    
    UITextField *textfiled = [[UITextField alloc]init];
    self.textfiled = textfiled;
    textfiled.font = [UIFont systemFontOfSize:14.0/375.0*WSCREEN];
    textfiled.placeholder = self.textfiledStr;
    textfiled.textAlignment = NSTextAlignmentRight;
    textfiled.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:textfiled];
    [textfiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgv);
        make.left.mas_equalTo(titlelab.mas_right).offset(20.0/375.0*WSCREEN);
        make.right.mas_equalTo(bgv).offset(-30.0/375.0*WSCREEN);
    }];
    
    UILabel *sizelab = [[UILabel alloc]init];
    sizelab.font = [UIFont systemFontOfSize:16.0/375.0*WSCREEN];
    sizelab.text = @"G";
    self.sizelab = sizelab;
    [self.view addSubview:sizelab];
    [sizelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgv);
        make.right.mas_equalTo(bgv).offset(-10.0/375.0*WSCREEN);
    }];
    
    UILabel *noticelab = [[UILabel alloc]init];
    noticelab.text = @"1 GB = 1024 MB";
    noticelab.textColor = ColorWithRGB(99, 99, 99);
    noticelab.font = [UIFont systemFontOfSize:12.0/375.0*WSCREEN];
    [self.view addSubview:noticelab];
    [noticelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(titlelab);
        make.top.mas_equalTo(bgv.mas_bottom).offset(20.0/667.0*HSCREEN);
    }];
    
    UIButton *Gbtn = [[UIButton alloc]init];
    Gbtn.tag = 222;
    [Gbtn setTitle:@"GB" forState:(UIControlStateNormal)];
    [Gbtn addTarget:self action:@selector(GMbtnClickWithBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    Gbtn.titleLabel.font = [UIFont systemFontOfSize:15.0/375.0*WSCREEN];
    [Gbtn setTitleColor:ColorWithRGB(99, 99, 99) forState:(UIControlStateSelected)];
    [Gbtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.view addSubview:Gbtn];
    [Gbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(noticelab);
        make.right.mas_equalTo(bgv).offset(-20.0/375.0*WSCREEN);
        make.width.mas_equalTo(40.0/375.0*WSCREEN);
        make.height.mas_equalTo(30.0/667.0*HSCREEN);
    }];
    self.currBtn = Gbtn;
    self.currBtn.selected = YES;
    
    UIButton *Mbtn = [[UIButton alloc]init];
    Mbtn.tag = 408;
    Mbtn.titleLabel.font = [UIFont systemFontOfSize:15.0/375.0*WSCREEN];
    [Mbtn addTarget:self action:@selector(GMbtnClickWithBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [Mbtn setTitleColor:ColorWithRGB(99, 99, 99) forState:(UIControlStateSelected)];
    [Mbtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [Mbtn setTitle:@"MB" forState:(UIControlStateNormal)];
    [self.view addSubview:Mbtn];
    [Mbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(Gbtn);
        make.right.mas_equalTo(Gbtn.mas_left).offset(-10.0/375.0*WSCREEN);
        make.size.mas_equalTo(Gbtn);
    }];
}

-(void)GMbtnClickWithBtn:(UIButton *)btn{
    self.currBtn.selected = NO;
    self.currBtn = btn;
    self.currBtn.selected = YES;
    if (btn.tag == 408) {
        self.sizelab.text = @"M";
    }else{
        self.sizelab.text = @"G";
    }
}

@end
