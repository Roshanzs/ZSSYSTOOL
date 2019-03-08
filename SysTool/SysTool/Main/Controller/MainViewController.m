//
//  MainViewController.m
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/13.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "MainViewController.h"
#import "HeadTopView.h"
#import "NSObject+NetWorkStateTool.h"

#import "MainCollectionViewCell.h"
#import "PresentViewController.h"

#define maincolleccellid @"maincolleccellid"

#define marginw (20.0/375.0*WSCREEN)
#define collectionW ((WSCREEN-4*marginw)/3.0)

@interface MainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionview;

@property(nonatomic,strong)HeadTopView *topView;
@property(nonatomic,assign)int numInt;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.numInt = 1;
    [self setupUI];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self WillShowBeforGet];
}

//界面显示之前获取
-(void)WillShowBeforGet{
    [[NetWorkInfoTool sharedManager] getDeviceIPAddressesWithBlock:^(NSString * _Nonnull ipStr) {
        [NetModel share].IPSTR = ipStr;
    }];
    [[DeviceDataTool sharedManager] getCPUFrequencyWithBlock:^(NSInteger freIntgeer) {
        [NetModel share].CPUHZ = [NSString stringWithFormat:@"%ldMHz", freIntgeer];
    }];
}


-(void)setupUI{

    
    UILabel *titlelab = [[UILabel alloc]init];
    titlelab.text = @"For SYS";
    titlelab.font = [UIFont systemFontOfSize:20];
    titlelab.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelab;
    
    [self.view addSubview:self.collectionview];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:maincolleccellid forIndexPath:indexPath];
    [ShareTools ZScorner:cell WithFlote:10];
    cell.index = indexPath;
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionW, 80);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PresentViewController *presentVC = [[PresentViewController alloc]initWithIndex:indexPath];
    [self presentViewController:presentVC animated:YES completion:^{
    }];
}



//-(UIView *)creatHeadView{
//    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 190.0/667.0*HSCREEN)];
//    self.topView = [[HeadTopView alloc]init];
//    _topView.backgroundColor = [UIColor whiteColor];
//    [ShareTools ZScorner:_topView WithFlote:15.0/375.0*WSCREEN];
//    [headV addSubview:_topView];
//    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(headV).offset(10.0/667.0*HSCREEN);
//        make.left.mas_equalTo(headV).offset(20.0/375.0*WSCREEN);
//        make.right.mas_equalTo(headV).offset(-20.0/375.0*WSCREEN);
//        make.bottom.mas_equalTo(headV).offset(-20.0/667.0*HSCREEN);
//    }];
//    return headV;
//}

-(UICollectionView *)collectionview{
    if (_collectionview == nil) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
        _collectionview = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowlayout];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        [_collectionview registerClass:[MainCollectionViewCell class] forCellWithReuseIdentifier:maincolleccellid];
        _collectionview.backgroundColor = ColorWithRGB(74, 77, 108);
    }
    return _collectionview;
}

@end

