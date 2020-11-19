//
//  ViewController.m
//  ZFGesturePassword
//
//  Created by 58 on 2018/12/14.
//  Copyright © 2018年 58. All rights reserved.
//

#import "ViewController.h"
#import "ZFGesturePassword/ZFGesturePasswordViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
}
#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}
#pragma mark - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZFGesturePasswordViewController *vc = [[ZFGesturePasswordViewController alloc] init];
    vc.gesIndex = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Setter && Getter
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (NSArray *)dataSource{
    
    if (!_dataSource) {
        
        _dataSource = @[@"设置手势密码",
                        @"验证手势密码",
                        ];
    }
    return _dataSource;
}
@end
