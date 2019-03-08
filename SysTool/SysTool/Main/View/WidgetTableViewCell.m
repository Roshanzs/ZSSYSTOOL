//
//  WidgetTableViewCell.m
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/21.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "WidgetTableViewCell.h"

@interface WidgetTableViewCell()
@property(nonatomic,strong)UILabel *lab;
@property(nonatomic,strong)UIImageView *imgv;
@property(nonatomic,strong)UIView *coverV;
@end

@implementation WidgetTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = ColorWithRGB(222, 222, 222);;
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    UILabel *lab = [[UILabel alloc]init];
    lab.font = [UIFont systemFontOfSize:15.0/375.0*WSCREEN];
    lab.textColor = ColorWithRGB(99, 99, 99);
    self.lab = lab;
    [self.contentView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10.0/667.0*HSCREEN);
        make.left.mas_equalTo(10.0/375.0*WSCREEN);
    }];
    
    UIImageView *imgv = [[UIImageView alloc]init];
    self.imgv = imgv;
    [self.contentView addSubview:imgv];
    [ShareTools ZScorner:imgv WithFlote:13.0/375.0*WSCREEN];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(149.0/667.0*HSCREEN);
        make.width.mas_equalTo(357.0/375.0*WSCREEN);
    }];
    
    _coverV = [self CoverLock];
    [imgv addSubview:_coverV];
    [_coverV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(imgv);
        make.size.mas_equalTo(imgv);
    }];
}

-(void)setIndex:(NSIndexPath *)index{
    _index = index;
    _imgv.image = [UIImage imageNamed:[NSString stringWithFormat:@"widgettype%ld",(long)index.row+1]];
    NSString *typestr = [ShareTools ChackADWithid:[NSString stringWithFormat:@"typecover%ld",(long)index.row]];
    if (index.row == 0) {
        _coverV.alpha = 0;
    }else{
        if (typestr.intValue >= 10) {
            _coverV.alpha = 0;
        }

    }
    if (index.row == 0) {
        _lab.text = @"样式一";
    }else if(index.row == 1){
        _lab.text = @"样式二";
    }else{
        _lab.text = @"样式三";
    }
}


-(UIView *)CoverLock{
    UIView *coverV = [[UIView alloc]init];
    coverV.backgroundColor = ColorWithRGB(99, 99, 99);
    coverV.alpha = 0.5;
    UIImageView *imgv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lockimg"]];
    [coverV addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(coverV);
        make.width.height.mas_equalTo(75.0/375.0*WSCREEN);
    }];
    return coverV;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
