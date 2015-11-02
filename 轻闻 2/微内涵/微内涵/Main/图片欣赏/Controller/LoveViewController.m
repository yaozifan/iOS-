//
//  LoveViewController.m
//  微内涵
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "LoveViewController.h"
#import "LoveCell.h"
#import "AFNateWorking.h"
#import "DetailLoveController.h"
#import "UIViewController+MMDrawerController.h"
#import "MJRefresh.h"
#import "UIScrollView+MJRefresh.h"
 @interface LoveViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*_table1;
    UITableView*_table2;
    NSMutableArray*_dataArray;
    NSMutableArray*_tableArray1;
    NSMutableArray*_tableArray2;
    NSInteger page ;//页数
}
@end

@implementation LoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阅读";
    [self creatTableView];
    [self loadData];
    page = 1;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Red2.jpg"]];
    _dataArray = [[NSMutableArray alloc] init];
}

#pragma mark - 处理数据
- (void)loadData
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@20 forKey:@"num"];
    
    [self showHud:@"稍等一下哟"];
    
    [AFNateWorking afNetWorking:@"http://apis.baidu.com/txapi/weixin/wxhot"
                         params:dic
                          metod:@"GET"
                completionBlock:^(id completion) {
                    NSMutableArray*tableArray = [[NSMutableArray alloc] init];
                    for (int i =0; i<20; i++)
                    {
                        NSString *STR = [NSString stringWithFormat:@"%d",i];
                        NSDictionary*dicID = completion[STR];
                        LoveModel *model = [[LoveModel alloc] init];
                        model.title = dicID[@"title"];
                        model.descriptionID = dicID[@"description"];
                        model.picUrl = dicID[@"picUrl"];
                        model.url = dicID[@"url"];
                        [tableArray addObject:model];

                    }
                    _tableArray1 = [[NSMutableArray alloc] init];
                    _tableArray2 = [[NSMutableArray alloc] init];

                    NSArray*array1 = [tableArray subarrayWithRange:NSMakeRange(0, 10)];
                    NSArray *array2 =[tableArray subarrayWithRange:NSMakeRange(9, 10)];
                    [_tableArray1 addObjectsFromArray:array1];
                    [_tableArray2 addObjectsFromArray:array2];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_table2 reloadData];
                        [_table1 reloadData];
                        [self hideHud];
                        [_table1.footer endRefreshing];
                        [_table2.footer endRefreshing];
                      
                    });
                }
                     errorBlock:^(NSError *error) {
                       NSLog(@"%@",error);
                }];
}
- (void)_loadNewData
{
    [self loadData];
}
#pragma mrak -下拉加载更多
- (void)_loadMoreData
{
    page ++;
    NSLog(@"%li",page);
    NSNumber *pa = [NSNumber numberWithInteger:page];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:pa forKey:@"page"];
    [dic setValue:@20 forKey:@"num"];
    [AFNateWorking afNetWorking:@"http://apis.baidu.com/txapi/weixin/wxhot"
                         params:dic
                          metod:@"GET"
                completionBlock:^(id completion) {
                    NSMutableArray*tableArray = [[NSMutableArray alloc] init];
                    for (int i =0; i<20; i++)
                    {
                        NSString *STR = [NSString stringWithFormat:@"%d",i];
                        NSDictionary*dicID = completion[STR];
                        LoveModel *model = [[LoveModel alloc] init];
                        model.title = dicID[@"title"];
                        model.descriptionID = dicID[@"description"];
                        model.picUrl = dicID[@"picUrl"];
                        model.url = dicID[@"url"];
                        [tableArray addObject:model];
                        
                    }
                
                    NSMutableArray * array3= [NSMutableArray arrayWithArray:(NSMutableArray*)[tableArray subarrayWithRange:NSMakeRange(0, 5)]] ;
                    NSMutableArray *array4= [NSMutableArray arrayWithArray:(NSMutableArray*)[tableArray subarrayWithRange:NSMakeRange(5, 5)]] ;
                    
                    [_tableArray1 addObjectsFromArray:array3];
                    [_tableArray2 addObjectsFromArray:array4];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_table2 reloadData];
                        [_table1 reloadData];
                        [_table1.footer endRefreshing];
                        [_table2.footer endRefreshing];
                    });
                } errorBlock:^(NSError *error) {
                    NSLog(@"%@",error);
                }];
}


- (void)creatTableView
{
    UITableView*table = [[UITableView alloc] init];
    [self.view addSubview: table];
    
    _table1 = [[UITableView alloc] initWithFrame:CGRectMake(20, 64, (KSCREENWIDTH-30)/2, KSCREENHEIGHT-64) style:UITableViewStylePlain];
    _table2 = [[UITableView alloc] initWithFrame:CGRectMake((KSCREENWIDTH-30)/2+10, 64, (KSCREENWIDTH-30)/2, KSCREENHEIGHT-64) style:UITableViewStylePlain];
    
    NSArray *tableArray = @[_table1,_table2];
    for (UITableView *tableView in tableArray)
    {
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.delegate = self;
        tableView.dataSource =self;
        [self.view addSubview:tableView];
    }
    //添加下拉刷新
    _table1.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    _table2.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
    
}

#pragma mark-数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _table1)
    {
        return _tableArray1.count;
    }
    return _tableArray2.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoveCell*cell = [tableView dequeueReusableCellWithIdentifier:@"loveCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LoveCell" owner:self options:nil]lastObject];
    }
    
    if (tableView == _table1)
    {
        cell.model = _tableArray1[indexPath.row];
        
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else if (tableView == _table2)
    {
        cell.model = _tableArray2[indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
       return cell;
    }
    return nil;
}
#pragma mark -模拟瀑布流
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _table1)
    {
        int i = rand()%30+200;
        return i;
        
    }
    else if (tableView == _table2)
    {
        int i = rand()%30+200;
        return i;
    }
    return 0;
}
#pragma mark - 同时滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray*array = @[_table1,_table2];
    
    for (UIScrollView *scro in array) {
        if (scro != scrollView) {
            scro.contentOffset = scrollView.contentOffset;
        }
    }
}
#pragma mark - 单元格的点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailLoveController*love = [[DetailLoveController alloc] init];
    
    if (tableView == _table1)
    {
        LoveModel*model = _tableArray1[indexPath.row];
        love.loveid = model.url;
    
    }
    else if (tableView == _table2)
    {
        LoveModel*model = _tableArray2[indexPath.row];
        love.loveid = model.url;
    }
    
    [self.navigationController pushViewController:love animated:YES];


}

@end
