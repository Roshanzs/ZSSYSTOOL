//
//  NetSpeedView.m
//  SysTool
//
//  Created by 紫贝壳 on 2019/1/9.
//  Copyright © 2019年 stark. All rights reserved.
//

#import "NetSpeedView.h"
#import "UIView+Style.h"
#import "NetSpeedTool.h"

#define INSIDE_RADIU  (95.0/375.0*WSCREEN)  // 内圈半径
#define OUTSIDE_RADIU  (160.0/375.0*WSCREEN) // 外圈半径
#define PROGRESS_RADIU (110.0/375.0*WSCREEN) // 进度条半径

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface NetSpeedView()

@property (nonatomic, assign) CGPoint m_Center;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *progessLineLayer;
@property (nonatomic, strong) UILabel *s_NumLabel;
@property (nonatomic, strong) UILabel *s_StausLabel;
@property (nonatomic, strong) UILabel *s_TimeLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *speedNum;
@property(nonatomic,strong)UILabel *currSpeed;
@property(nonatomic,strong)UILabel *currSpeedPercent;
@property(nonatomic,strong)UILabel *KDSpeed;
@property(nonatomic,strong)UIButton *testBtn;
@property(nonatomic,assign)CGFloat textAngel;

@end

@implementation NetSpeedView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.m_Center = CGPointMake(frame.size.width/2, frame.size.height/2.5);
        [self initial];
    }
    return self;
}

- (void)initial
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.s_NumLabel];
    [self addSubview:self.s_StausLabel];
    [self addSubview:self.s_TimeLabel];
    [self drawInsideArc];
    [self drawOutsideBg];
    [self drawOutsideArc];
    [self drawProgreeArc];
    [self drawProgreeLineArc];
    [self resultView];
}


// 评分展示
- (UILabel *)s_NumLabel
{
    if (!_s_NumLabel) {
        _s_NumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2 - INSIDE_RADIU, self.height/2-75, INSIDE_RADIU*2, 35.0/667.0*HSCREEN)];
        _s_NumLabel.font = [UIFont boldSystemFontOfSize:20.0/375.0*WSCREEN];
        _s_NumLabel.textColor = RGBA(239, 80, 59, 1);
        _s_NumLabel.textAlignment = NSTextAlignmentCenter;
        _s_NumLabel.text = @"0K/s";
    }
    return _s_NumLabel;
}

// 状态
- (UILabel *)s_StausLabel
{
    if (!_s_StausLabel) {
        _s_StausLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2 - INSIDE_RADIU, self.s_NumLabel.bottom+5, INSIDE_RADIU*2, 20.0/667.0*HSCREEN)];
        _s_StausLabel.font = [UIFont systemFontOfSize:14.0/375.0*WSCREEN];
        _s_StausLabel.textColor = RGBA(239, 80, 59, 1);
        _s_StausLabel.textAlignment = NSTextAlignmentCenter;
        _s_StausLabel.text = @"正常";
    }
    return _s_StausLabel;
}

// 时间
- (UILabel *)s_TimeLabel
{
    if (!_s_TimeLabel) {
        _s_TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2 - INSIDE_RADIU, self.s_StausLabel.bottom, INSIDE_RADIU*2, 18.0/667.0*HSCREEN)];
        _s_TimeLabel.font = [UIFont systemFontOfSize:12.0/375.0*WSCREEN];
        _s_TimeLabel.textColor = [UIColor lightGrayColor];
        _s_TimeLabel.textAlignment = NSTextAlignmentCenter;
        _s_TimeLabel.text = [NSString stringWithFormat:@"测速时间:%@",[ShareTools creatTimeFromDate]];
    }
    return _s_TimeLabel;
}


// 内弧线
- (void)drawInsideArc
{
    //主要解释一下各个参数的意思
    //center  中心点（可以理解为圆心）
    //radius  半径
    //startAngle 起始角度
    //endAngle  结束角度
    //clockwise  是否顺时针
    
    CGFloat perAngle = M_PI / 80;
    for (int i = 0; i< 81; i++) {
        CGFloat startAngel = (-M_PI + perAngle * i);
        CGFloat endAngel   = startAngel + perAngle/3;
        UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:self.m_Center radius:INSIDE_RADIU startAngle:startAngel endAngle:endAngel clockwise:YES];
        CAShapeLayer *perLayer = [CAShapeLayer layer];
        perLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        perLayer.lineWidth   = 1.f;
        perLayer.path = tickPath.CGPath;
        [self.layer addSublayer:perLayer];
    }
}

- (void)drawOutsideBg
{
    CGFloat perAngle = M_PI / 50;
    //我们需要计算出每段弧线的起始角度和结束角度
    //这里我们从- M_PI 开始，我们需要理解与明白的是我们画的弧线与内侧弧线是同一个圆心
    for (int i = 0; i< 51; i++) {
        CGFloat startAngel = (-M_PI + perAngle * i);
        CGFloat endAngel   = startAngel + perAngle;
        UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:self.m_Center radius:OUTSIDE_RADIU startAngle:startAngel endAngle:endAngel clockwise:YES];
        CAShapeLayer *perLayer = [CAShapeLayer layer];
        perLayer.lineWidth  = 30.0/375.0*WSCREEN;
        perLayer.strokeColor = [self getBgColor:i].CGColor;
        if (i % 5 == 0) {
            [self drawOutsideScaleWithAngel:endAngel withData:i];
        }
        perLayer.path = tickPath.CGPath;
        [self.layer addSublayer:perLayer];
    }
}

// 获取渐变背景色
- (UIColor *)getBgColor:(NSInteger)value
{
    float one = (255 + 255) / 60;//（255+255）除以最大取值的三分之二
    int r=0,g=0,b=0;
    if (value < 30)//第一个三等分
    {
        r = 255;
        g = (int)(one * value);
    }
    else if (value >= 30 && value < 60)//第二个三等分
    {
        r =  255 - (int)((value - 30) * one);//val减最大取值的三分之一;
        g = 255;
    }
    else { g = 255; }//最后一个三等分
    return RGBA(r, g, b, 1.0);
}

// 外侧弧线分割
- (void)drawOutsideArc
{
    CGFloat perAngle = M_PI / 5;
    //我们需要计算出每段弧线的起始角度和结束角度
    //这里我们从- M_PI 开始，我们需要理解与明白的是我们画的弧线与内侧弧线是同一个圆心
    for (int i = 1; i< 5; i++) {
        CGFloat startAngel = (-M_PI + perAngle * i);
        CGFloat endAngel   = startAngel + perAngle/80;
        UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:self.m_Center radius:OUTSIDE_RADIU startAngle:startAngel endAngle:endAngel clockwise:YES];
        CAShapeLayer *perLayer = [CAShapeLayer layer];
        perLayer.lineWidth   = 30.0/375.0*WSCREEN;
        perLayer.strokeColor = [UIColor whiteColor].CGColor;
        perLayer.path = tickPath.CGPath;
        [self.layer addSublayer:perLayer];
    }
    
}


// 外侧 刻度
- (void)drawOutsideScaleWithAngel:(CGFloat)textAngel withData:(int)index
{
    CGPoint point = [self calculateTextPositonWithArcCenter:self.m_Center Angle:-textAngel];
    NSString *tickText = [NSString stringWithFormat:@"%d%%",index * 2];
    if (index % 10 == 0) {
//        tickText = [NSString stringWithFormat:@"%d",index * 2 *10];
    }else{
        if (index == 5) {
            tickText = @"超慢";
        }else if(index == 15){
            tickText = @"较慢";
        }else if(index == 25){
            tickText = @"快";
        }else if(index == 35){
            tickText = @"较快";
        }else if(index == 45){
            tickText = @"超快";
        }
    }
    //默认label的大小30 * 14
    UILabel *text      = [[UILabel alloc] initWithFrame:CGRectMake(point.x - 15.0/375.0*WSCREEN, point.y - 8.0/667.0*HSCREEN, 30.0/375.0*WSCREEN, 14.0/667.0*HSCREEN)];
    text.text          = tickText;
    text.font          = [UIFont systemFontOfSize:10.0/375.0*WSCREEN];
    text.textColor     = [UIColor colorWithRed:0.54 green:0.78 blue:0.91 alpha:1.0];
    text.textAlignment = NSTextAlignmentCenter;
    [self addSubview:text];
    
}


//默认计算半径135
- (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center
                                       Angle:(CGFloat)angel
{
    CGFloat x = 135.0 * cosf(angel)/375.0*WSCREEN;
    CGFloat y = 135.0 * sinf(angel)/375.0*WSCREEN;
    return CGPointMake(center.x + x, center.y - y);
}


// 绘制进度填充
- (void)drawProgreeArc
{
    UIBezierPath *progressPath  = [UIBezierPath bezierPathWithArcCenter:self.m_Center
                                                                 radius:130.0/375.0*WSCREEN
                                                             startAngle:- M_PI
                                                               endAngle:0
                                                              clockwise:YES];
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.lineWidth     =  30.0/375.0*WSCREEN;
    self.progressLayer.fillColor     = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor   =  RGBA(185,243,110,0.2).CGColor;
    self.progressLayer.path          = progressPath.CGPath;
    self.progressLayer.strokeStart   = 0;
    self.progressLayer.strokeEnd     = 0;
    [self.layer addSublayer:self.progressLayer];
}

// 绘制进度曲线

- (void)drawProgreeLineArc
{
    UIBezierPath *progressPath  = [UIBezierPath bezierPathWithArcCenter:self.m_Center
                                                                 radius:118.0/375.0*WSCREEN
                                                             startAngle:- M_PI
                                                               endAngle:0
                                                              clockwise:YES];
    self.progessLineLayer = [CAShapeLayer layer];
    self.progessLineLayer.lineWidth     =  2.0/375.0*WSCREEN;
    self.progessLineLayer.fillColor     = [UIColor clearColor].CGColor;
    self.progessLineLayer.strokeColor   =  RGBA(236,92,55,1).CGColor;
    self.progessLineLayer.path          = progressPath.CGPath;
    self.progessLineLayer.strokeStart   = 0;
    self.progessLineLayer.strokeEnd     = 0;
    [self.layer addSublayer:self.progessLineLayer];
}


-(void)setSpeedNum:(NSString *)speedNum{
    _speedNum = speedNum;
    NSString *crditStatus = @"飞机";
    if (speedNum.floatValue <= 100) {
        crditStatus = @"龟速";
    }else if (speedNum.floatValue <= 300 && speedNum.floatValue > 100){
        crditStatus = @"自行车";
    }else if (speedNum.floatValue <= 500 && speedNum.floatValue > 300){
        crditStatus = @"汽车";
    }else if (speedNum.floatValue <= 600 && speedNum.floatValue > 500){
        crditStatus = @"高铁";
    }else if (speedNum.floatValue <= 800 && speedNum.floatValue > 600){
        crditStatus = @"飞机";
    }else{
        crditStatus = @"火箭";
    }
    self.s_StausLabel.text = crditStatus;
    [self creditAnimationBegin:0 End:speedNum.floatValue];
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat endStoke = speedNum? speedNum.floatValue/1000:0;
        self.textAngel = endStoke;
        self.progressLayer.strokeEnd = endStoke;
        self.progessLineLayer.strokeEnd = endStoke;
    }];
}


// 数字动画
- (void)creditAnimationBegin:(int)begin End:(int)end{
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionary];
    [userinfo setObject:@(begin) forKey:@"beginNumber"];
    [userinfo setObject:@(end) forKey:@"endNumber"];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1/20.0 target:self selector:@selector(changeNumberAnimation:) userInfo:userinfo repeats:YES];
    
}

- (void)changeNumberAnimation:(NSTimer *)timer{
    
    int begin = [timer.userInfo[@"beginNumber"] floatValue];
    int end = [timer.userInfo[@"endNumber"] floatValue];
    int current = begin;
    current += 50;
    [timer.userInfo setObject:@(current) forKey:@"beginNumber"];
    if (current >= end) {
        current = end;
    }
    self.s_NumLabel.text = [NSString stringWithFormat:@"%@/s",[ShareTools getFileSizeString:current*3072.0]];
    if (current == end) {
        [timer invalidate];
        self.timer = nil;
    }
}

-(void)resultView{
    UILabel *currSpeed = [[UILabel alloc]init];
    self.currSpeed = currSpeed;
    currSpeed.text = @"平均速度:";
    currSpeed.textColor = [UIColor whiteColor];
    currSpeed.font = [UIFont systemFontOfSize:14.0/375.0*WSCREEN];
    [self addSubview:currSpeed];
    [currSpeed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.s_TimeLabel.mas_bottom).offset(30.0/667.0*HSCREEN);
        make.left.mas_equalTo(30.0/375.0*WSCREEN);
    }];

    UILabel *currSpeedPercent = [[UILabel alloc]init];
    self.currSpeedPercent = currSpeedPercent;
    currSpeedPercent.text = @"速度排名:";
    currSpeedPercent.textColor = [UIColor whiteColor];
    currSpeedPercent.font = [UIFont systemFontOfSize:14.0/375.0*WSCREEN];
    [self addSubview:currSpeedPercent];
    [currSpeedPercent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(currSpeed);
        make.left.mas_equalTo(self.mas_centerX);
    }];
    
    UILabel *KDSpeed = [[UILabel alloc]init];
    self.KDSpeed = KDSpeed;
    KDSpeed.textColor = [UIColor orangeColor];
    KDSpeed.font = [UIFont systemFontOfSize:24.0/375.0*WSCREEN];
    KDSpeed.text = @"";
    [self addSubview:KDSpeed];
    [KDSpeed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(currSpeedPercent.mas_bottom).offset(30.0/667.0*HSCREEN);
    }];
    
    UIButton *testBtn = [[UIButton alloc]init];
    self.testBtn = testBtn;
    [ShareTools ZScorner:testBtn WithFlote:10.0/375.0*WSCREEN];
    [testBtn setTitle:@"开始" forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(beginTest) forControlEvents:UIControlEventTouchUpInside];
    testBtn.backgroundColor = [UIColor orangeColor];
    [self addSubview:testBtn];
    [testBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(KDSpeed.mas_bottom).offset(50.0/667.0*HSCREEN);
        make.width.mas_equalTo(200.0/375.0*WSCREEN);
        make.height.mas_equalTo(50.0/667.0*HSCREEN);
    }];
    
}

-(void)beginTest{
    [self.testBtn setTitle:@"测速中..." forState:UIControlStateNormal];
    self.testBtn.backgroundColor = [UIColor grayColor];
    self.testBtn.enabled = NO;
    self.currSpeed.text = [NSString stringWithFormat:@"平均速度:"];
    self.currSpeedPercent.text = [NSString stringWithFormat:@"速度排名:"];
    self.KDSpeed.text = [NSString stringWithFormat:@""];
    NetSpeedTool * meaurNet = [[NetSpeedTool alloc] initWithblock:^(float speed) {
        self.speedNum = [NSString stringWithFormat:@"%f",speed/3072.0];
    } finishMeasureBlock:^(float speed) {
        NSString* speedStr = [NSString stringWithFormat:@"%@/s", [ShareTools getFileSizeString:speed]];
        self.speedNum = [NSString stringWithFormat:@"%f",speed/3072.0];
        self.currSpeed.text = [NSString stringWithFormat:@"平均速度:%@",speedStr];
        self.currSpeedPercent.text = [NSString stringWithFormat:@"排名:打败%.0f%%的用户",self.textAngel>1?0.99:self.textAngel*100];
        self.KDSpeed.text = [NSString stringWithFormat:@"相当于 %@ 宽带",[ShareTools formatBandWidth:speed]];
        [self.testBtn setTitle:@"开始" forState:UIControlStateNormal];
        self.testBtn.backgroundColor = [UIColor orangeColor];
        self.testBtn.enabled = YES;
    } failedBlock:^(NSError *error) {
        [EasyTextView showErrorText:@"测速失败!请重试一次"];
        [self.testBtn setTitle:@"开始" forState:UIControlStateNormal];
        self.testBtn.backgroundColor = [UIColor orangeColor];
        self.testBtn.enabled = YES;
    }];
    [meaurNet startMeasur];
}


@end
