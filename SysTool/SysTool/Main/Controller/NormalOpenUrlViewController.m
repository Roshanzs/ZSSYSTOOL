//
//  NormalOpenUrlViewController.m
//  SysTool
//
//  Created by 紫贝壳 on 2019/1/4.
//  Copyright © 2019年 stark. All rights reserved.
//

#import "NormalOpenUrlViewController.h"

@interface NormalOpenUrlViewController()
@property(nonatomic,strong)UILabel *textlab;
@end

@implementation NormalOpenUrlViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *titlab = [[UILabel alloc]init];
    titlab.text = @"示例";
    titlab.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlab;
    CGRect statusRect=[[UIApplication sharedApplication] statusBarFrame];
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WSCREEN, self.navigationController.navigationBar.frame.size.height + statusRect.size.height)];
    headview.backgroundColor = ColorWithRGB(74, 77, 108);
    [self.view addSubview:headview];
    [self setUpUI];
}


-(void)setUpUI{
    UIScrollView *scrollview = [[UIScrollView alloc]init];
    [self.view addSubview:scrollview];
    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(self.view);
    }];
    [scrollview addSubview:self.textlab];
    [self.textlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scrollview).offset(80.0/667.0*HSCREEN);
        make.left.mas_equalTo(scrollview).offset(40.0/375.0*WSCREEN);
        make.bottom.right.mas_equalTo(scrollview).offset(-40.0/375.0*WSCREEN);
    }];
    
}

-(UILabel *)textlab{
    if (_textlab == nil) {
        _textlab = [[UILabel alloc]init];
        _textlab.numberOfLines = 0;
        _textlab.textColor = [UIColor blackColor];
        _textlab.font = [UIFont systemFontOfSize:18.0/375.0*WSCREEN];
        _textlab.text = @"微博 sinaweibo://\r\n优酷 youku://\r\n美拍 tencent101022619://\r\n唱吧 changba://\r\n京东 openApp.jdMobile://\r\n同步推 wxef5b6333c715b7bd://\r\n爱奇艺 qiyi-iphone://\r\n万年历 tencent100294478://\r\n网易新闻 QQ14AC1032://\r\n百度贴吧 tencent100385258://\r\nQQ空间 tencentapi.qzone.reqContent://\r\n虾米音乐 sinaweibosso.3845915579://\r\nInstagram instagram://\r\nUC浏览器 QQ367B7700://\r\n天天酷跑 tencent100692648://\r\nQQ音乐 tencent100497308.content://\r\n美图秀秀 mtxx://\r\n酷狗音乐 tencent205141://\r\n美颜相机 myxj://\r\n腾讯视频 tencent100498506://\r\n腾讯新闻 QQ6BF159C6://\r\n百度视频 sinaweibosso.1706388304://\r\n搜狐视频 wxb6c82517aa33d525://\r\n有道词典 yddictproapp://\r\n百度地图 bdmap://\r\n网易云音乐 orpheus://\r\n12306订票助手 trainassist://\r\n高铁管家 gtgj://\r\n爱奇艺PPS ppstream://\r\n哔哩哔哩动画 bilibili://\r\n旺旺卖家版 wangwangseller://\r\n优酷 youku://\r\n旺信 wangxin://\r\n土豆视频 tudou://\r\n墨迹天气 rm434209233MojiWeather://\r\n支付宝 alipay://\r\n酷我音乐 com.kuwo.kwmusic.kwmusicForKwsing://\r\n京东 openApp.jdMobile://\r\n今日头条 snssdk141://\r\n天猫 tmall://\r\n新浪微博 weibo:// 或 sinaweibo://\r\n高德导航 Autonavi://\r\n淘宝 taobao://\r\n微信 wechat:// 或 weixin://\r\n百度云 baiduyun://";
    }
    return _textlab;
}

@end
