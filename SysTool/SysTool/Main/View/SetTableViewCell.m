//
//  SetTableViewCell.m
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/16.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "SetTableViewCell.h"

@interface SetTableViewCell()
@end

@implementation SetTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.font = [UIFont systemFontOfSize:14.0/375.0*WSCREEN];
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
}

-(void)setIndex:(NSIndexPath *)index{
    _index = index;
    if (index.section == 0) {
    switch (index.row) {
        case 0:
            self.imageView.image = [UIImage imageNamed:@"liuliangimg"];
            self.textLabel.text = @"流量套餐设置";
            break;
        case 1:
            self.imageView.image = [UIImage imageNamed:@"liuliangupdawn"];
            self.textLabel.text = @"流量使用详情";
            break;
        case 2:
            self.imageView.image = [UIImage imageNamed:@"widgetimg"];
            self.textLabel.text = @"Widget样式";
            break;
        case 3:
            self.imageView.image = [UIImage imageNamed:@"kuaijieimg"];
            self.textLabel.text = @"快捷打开设置";
            break;
        default:
            break;
    }
    }else if (index.section == 1){
        switch (index.row) {
            case 0:
                self.imageView.image = [UIImage imageNamed:@"guidecellimg"];
                self.textLabel.text = @"新手引导";
                break;
            case 1:
                self.imageView.image = [UIImage imageNamed:@"dianzan"];
                self.textLabel.text = @"推荐给朋友";
                break;
            case 2:
                self.imageView.image = [UIImage imageNamed:@"fankuiimg"];
                self.textLabel.text = @"意见反馈";
                break;
            case 3:
                self.imageView.image = [UIImage imageNamed:@"banbenimg"];
                self.textLabel.text = @"版本";
                break;
            default:
                break;
        }
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
