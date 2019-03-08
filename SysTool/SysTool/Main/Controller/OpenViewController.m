//
//  OpenViewController.m
//  SysTool
//
//  Created by 紫贝壳 on 2018/12/29.
//  Copyright © 2018年 stark. All rights reserved.
//

#import "OpenViewController.h"
#import "NormalOpenUrlViewController.h"

#define opencellid @"opencellid"

@interface OpenViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *openUrlArr;
@end


@implementation OpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorWithRGB(222, 222, 222);
    UILabel *titlab = [[UILabel alloc]init];
    titlab.text = @"快捷打开";
    titlab.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlab;
    CGRect statusRect=[[UIApplication sharedApplication] statusBarFrame];
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WSCREEN, self.navigationController.navigationBar.frame.size.height + statusRect.size.height)];
    headview.backgroundColor = ColorWithRGB(74, 77, 108);
    NSDictionary *urldic = [ShareTools openUrlArrDic];
    self.openUrlArr = [NSMutableArray arrayWithArray:[urldic objectForKey:@"urlarr"]];
    [self.view addSubview:self.tableview];
    [self.view addSubview:headview];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:(UIBarButtonItemStylePlain) target:self action:@selector(addWidgetOpen)];
}

-(void)addWidgetOpen{
    UIAlertController *addalter = [UIAlertController alertControllerWithTitle:@"添加快捷方式" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *Likeaction = [UIAlertAction actionWithTitle:@"示例" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NormalOpenUrlViewController *normalvc = [[NormalOpenUrlViewController alloc]init];
        [self.navigationController pushViewController:normalvc animated:YES];
    }];
    UIAlertAction *Normalaction = [UIAlertAction actionWithTitle:@"添加常用" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *urlnormal = [ShareTools openUrlNormalArrDic];
        [ShareTools addOpenUrlWithArr:urlnormal];
        NSDictionary *urldic = [ShareTools openUrlArrDic];
        self.openUrlArr = [NSMutableArray arrayWithArray:[urldic objectForKey:@"urlarr"]];
        [self.tableview reloadData];
    }];
    UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *titlestr = addalter.textFields.firstObject.text;
        NSString *urlstr = addalter.textFields.lastObject.text;
        if (titlestr.length > 0 && urlstr.length > 0) {
            NSDictionary *dic = @{@"img":@"normalimg",@"imgWidget":@"normalimgWIDGET",@"title":titlestr,@"url":urlstr};
            [ShareTools addOpenUrlWithArr:@[dic]];
            NSDictionary *urldic = [ShareTools openUrlArrDic];
            self.openUrlArr = [NSMutableArray arrayWithArray:[urldic objectForKey:@"urlarr"]];
            [self.tableview reloadData];
            [EasyTextView showSuccessText:@"添加成功!"];
        }else{
            [EasyTextView showErrorText:@"添加失败,请重试!"];
        }
    }];
    
    [addalter addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"e.g. 微信";
    }];
    [addalter addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"e.g. wechat://";
    }];
    [addalter addAction:Likeaction];
    [addalter addAction:Normalaction];
    [addalter addAction:okaction];
    [addalter addAction:cancel];
    [self presentViewController:addalter animated:YES completion:^{
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [ShareTools openState].intValue;
    }
    return self.openUrlArr.count - [ShareTools openState].intValue;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:opencellid forIndexPath:indexPath];
    NSDictionary *dic = nil;
    if (indexPath.section == 0) {
       dic = self.openUrlArr[indexPath.row];
    }else{
        dic = self.openUrlArr[indexPath.row + [ShareTools openState].intValue];
    }
    cell.imageView.image = [UIImage imageNamed:[dic objectForKey:@"img"]];
    cell.textLabel.text = [dic objectForKey:@"title"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UILabel *lab = [[UILabel alloc]init];
        lab.text = @"拖动快捷方式到上方,最多只支持5个,多余的将不会显示!";
        lab.font = [UIFont systemFontOfSize:13.0/375.0*WSCREEN];
        lab.textColor = ColorWithRGB(99, 99, 99);
        lab.textAlignment = NSTextAlignmentCenter;
        return lab;
    }
    return [[UIView alloc]init];
}



-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [_tableview setEditing:editing animated:animated];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    int state = [ShareTools openState].intValue;
    if (sourceIndexPath.section == 0) {
        if (destinationIndexPath.section == 0) {
            [ShareTools changeOpenUrlArrWithFrom:sourceIndexPath.row To:destinationIndexPath.row WithisAdd:0];
        }else{
            [ShareTools changeOpenUrlArrWithFrom:sourceIndexPath.row To:destinationIndexPath.row+state-1 WithisAdd:-1];
        }
    }else{
        if (destinationIndexPath.section == 0) {
            if (state >= 5) {
                [ShareTools limiteFive];
                [tableView reloadData];
            }else{
                [ShareTools changeOpenUrlArrWithFrom:sourceIndexPath.row+state To:destinationIndexPath.row WithisAdd:1];
            }
        }else{
            [ShareTools changeOpenUrlArrWithFrom:sourceIndexPath.row+state To:destinationIndexPath.row+state WithisAdd:0];
        }
    }
}


-(UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight = 40.0/667.0*HSCREEN;
        _tableview.estimatedRowHeight = 40.0/667.0*HSCREEN;;
        [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:opencellid];
        _tableview.backgroundColor = [UIColor clearColor];
        [_tableview setEditing:YES animated:YES];
    }
    return _tableview;
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
