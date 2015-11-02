//
//  DetailGameController.m
//  微内涵
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "DetailGameController.h"
#import "AFNateWorking.h"
#import "DetailModel.h"
#import "DetailGameCell.h"
#import "MBProgressHUD.h"
#import "ExplainViewController.h"
@interface DetailGameController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray*_dataArray;
    UITableView*_datailTable;
    int p ;
    MBProgressHUD*_hud;
    
}
@end

@implementation DetailGameController
#pragma mark - 游戏详情页面
- (void)viewDidLoad {
    NSString*str = NSHomeDirectory();
    NSLog(@"%@",str);
    [super viewDidLoad];
    [self creatNavBar];
    [self creatTable];
    [self loadData];

}

- (void)creatNavBar
{
    UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:@"返回" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = item;
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 数据读取
- (void)loadData
{
    p++;
    NSString *urlString = [NSString stringWithFormat: @"http://api.dotaly.com/lol/api/v1/shipin/latest?author=%@&iap=0&ident=0&jb=0&limit=50&nc=0&offset=%d&tk=0",_gameID,p];
    _dataArray = [[NSMutableArray alloc] init];
     [self showHud:@"正在加载！请骚等"];
    [AFNateWorking afRequestData:urlString
                      HTTPMethod:@"GET"
                          parame:nil
                      completion:^(id completion) {
                           NSArray*array = completion[@"videos"];
                          for (NSDictionary*dic in array)
                          {
                              DetailModel*model = [[DetailModel alloc] init];
                              [model setValuesForKeysWithDictionary:dic];
                              [_dataArray addObject:model];
                          }
                          [_datailTable reloadData];

                          [self hideHud];
                      } errorBlock:^(NSError *error) {
                          
                      }];
}
#pragma mark - 菊花
- (void)showHud:(NSString*)title;
{
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.dimBackground = YES;//灰色背景视图
    }
    [_hud show:YES];
}
- (void)hideHud;
{
    [_hud hide:YES];
}


- (void)creatTable
{
    _datailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, KSCREENHEIGHT) style:UITableViewStylePlain];
    
    _datailTable.dataSource = self;
    _datailTable.delegate = self;
    
    
    [self.view addSubview:_datailTable];
}
#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailGameCell*cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailGameCell" owner:self options:nil]lastObject];
    }
    
    cell.model = _dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExplainViewController*explain = [[ExplainViewController alloc] init];
    
    DetailModel*model = _dataArray[indexPath.row];
    explain.model = model;
    
    [self.navigationController pushViewController:explain animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
