//
//  GameViewController.m
//  微内涵
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//
//视频页面接口
//http://223.6.252.214/weibofun/weibo_list.php?apiver=10500&category=weibo_videos&page=0&page_size=30&max_timestamp=-1&vip=1&platform=iphone&appver=1.6&udid=348293AF-1C93-4232-8B4D-CBA409EA4F28
#define SHIPING_URL @"http://223.6.252.214/weibofun/weibo_list.php?apiver=10500&category=weibo_videos&page=%d&page_size=15&max_timestamp=%d&vip=1&platform=0&appver=0&udid=0"
#import "GameViewController.h"
#import "AFNateWorking.h"
#import "GameModel.h"
#import "GameViewCell.h"
#import "DetailGameController.h"
#import "Mybutton.h"
#import "MovieModel.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import <MediaPlayer/MediaPlayer.h>
@interface GameViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD*_hud;
    UITableView*table1;
    UITableView*table2;
    UITableView*table3;
    NSMutableArray*_dataArray;
    NSMutableArray*_movieArray;
    NSArray*tableArray1;
    NSArray*tableArray2;
    NSArray*tableArray3;
    UIView*_lolView;
    UIView*_movieView;
    Mybutton*button;
    Mybutton*button1;
    UITableView*_movieTable;
    int _page;
    int _time;
    NSString*_timeString;
}
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"weiBJUI.jpg"]];
 
    _page = 1;
    //获取当前时间戳
    NSDate*date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a =[date timeIntervalSince1970];
    _timeString = [NSString stringWithFormat:@"%f",a];
    _time = _timeString.intValue;

    [self creatNavView];
    [self creatTable];
    [self loadData];
    [self movieLoadData];
    [self creatMovieView];
}

- (void)loadData
{
    [self showHud:@"休息一下吧"];
    _dataArray = [[NSMutableArray alloc] init];
    _movieArray = [[NSMutableArray alloc] init];
    //解析数据
    [AFNateWorking afRequestData:@"http://api.dotaly.com/lol/api/v1/authors?iap=0&ident=0&jb=0&nc=0&tk=0"
                      HTTPMethod:@"GET"
                          parame:nil
                      completion:^(id completion) {
                          NSArray*authors = completion[@"authors"];
                          for (NSDictionary*dic in authors)
                          {
                              GameModel*model = [[GameModel alloc] init];
                              model.name = dic[@"name"];
                              model.url = dic[@"url"];
                              model.gameID = dic[@"id"];
                              model.icon = dic[@"icon"];
                              model.pop = dic[@"pop"];
                              model.youku_id = dic[@"youku_id"];
                              [_dataArray addObject:model];
                          }
                          //取得从数组中的某个位置开始的指定个数的元素
                          tableArray1 = [_dataArray subarrayWithRange:NSMakeRange(0, 15)];
                          tableArray2 = [_dataArray subarrayWithRange:NSMakeRange(16, 15)];
                          tableArray3 = [_dataArray subarrayWithRange:NSMakeRange(31, 15)];
                        
                          [table1 reloadData];
                          [table2 reloadData];
                          [table3 reloadData];
                          [self hideHud];
                        }errorBlock:^(NSError *error) {
                         NSLog(@"%@",error);
    }];
    
}
//视频加载方式
- (void)movieLoadData
{
    NSString*urlString = [NSString stringWithFormat:SHIPING_URL,_page,_time];
    [self showHud:@"休息一下吧"];
    [AFNateWorking afNetWorking:urlString
                         params:nil
                          metod:@"GET"
                completionBlock:^(id completion) {
                    NSArray*itemsArray = completion[@"items"];
                    NSMutableArray*dataAr = [[NSMutableArray alloc] init];
                    for (NSDictionary*dic in itemsArray)
                    {
                        MovieModel*movie = [[MovieModel alloc] initWithDataDic:dic];
                        
                        [dataAr addObject:movie];
                    }
                    [_movieArray addObjectsFromArray:dataAr];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [_movieTable reloadData];
                        [self hideHud];
                    });
                    
                } errorBlock:^(NSError *error) {
                    
                    NSLog(@"翻转界面错误%@",error);
                }];
    
}
#pragma mark - 切换视图
- (void)creatNavView
{
    button = [Mybutton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(btnPicter) forControlEvents:UIControlEventTouchUpInside];
    button.selected = YES;
    
    [button setTitle:@"LOL" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17 weight:3];
    button.frame = CGRectMake(0, 0, KSCREENWIDTH/2, 25);
    
    button1 = [Mybutton buttonWithType:UIButtonTypeCustom];
    [button1 addTarget:self action:@selector(btnContent) forControlEvents:UIControlEventTouchUpInside];
    button1.titleLabel.font = [UIFont systemFontOfSize:17 weight:3];
    [button1 setTitle:@"笑一笑" forState:UIControlStateNormal];
    button1.frame = CGRectMake(KSCREENWIDTH/2,0, KSCREENWIDTH/2, 25);
    
    UIBarButtonItem*item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    UIBarButtonItem*item1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = item1;
    
}
#pragma mark- 点击翻转视图
- (void)btnPicter
{
    if (_lolView.hidden == NO) {
        return;
    }
    button.selected = YES;
    button1.selected = NO;
    [UIView transitionWithView:self.view
                      duration:.3
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        _movieView.hidden = YES;
                        _lolView.hidden = NO;
                    } completion:nil];
}

- (void)btnContent
{
    if (_movieView.hidden == NO) {
        return;
    }
    button.selected = NO;
    button1.selected = YES;
    [UIView transitionWithView:self.view
                      duration:.3
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        _movieView.hidden = NO;
                        _lolView.hidden = YES;
                        
                    } completion:nil];
        
}
- (void)creatMovieView
{
    _movieView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_movieView];
    _movieView.hidden = YES;
    _movieView.backgroundColor = [UIColor clearColor];

    _movieTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KSCREENWIDTH, KSCREENHEIGHT-110) style:UITableViewStylePlain];
    _movieTable.delegate = self;
    _movieTable.dataSource = self;
    _movieTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    _movieTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
    [_movieView addSubview:_movieTable];
}
//下拉刷新
- (void)_loadNewData
{
    //从第一页开始下载
    _page = 0;
    //重新下载数据
    _time=_timeString.intValue;
    [self movieLoadData];
    //结束下拉刷新
    [_movieTable.header endRefreshing];

}
//上拉更多
- (void)_loadMoreData
{
    _page += 1;
    //下载下一页数据
    //    60   一分种
    _time=_timeString.intValue-3600*_page*24;
    
    [self movieLoadData];
    //结束上拉加载更多
    [_movieTable.footer endRefreshing];

}

- (void)creatTable
{   //第一个添加到View的table位置会自动上移
    UITableView*table = [[UITableView alloc] init];
    [self.view addSubview:table];
    
    _lolView= [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _lolView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_lolView];
  
    table1 = [[UITableView alloc] initWithFrame:CGRectMake(2, 70, (KSCREENWIDTH-8)/3, KSCREENHEIGHT-120) style:UITableViewStylePlain];
    
    table2 = [[UITableView alloc] initWithFrame:CGRectMake((KSCREENWIDTH-8)/3, 70, (KSCREENWIDTH-8)/3, KSCREENHEIGHT-120) style:UITableViewStylePlain];
    
    table3 = [[UITableView alloc] initWithFrame:CGRectMake((KSCREENWIDTH-8)*2/3, 70, (KSCREENWIDTH-8)/3, KSCREENHEIGHT-120) style:UITableViewStylePlain];
    
    NSArray*array = @[table1,table2,table3];
    for (UITableView*table4 in array)
    {
        table4.delegate = self;
        table4.dataSource = self;
        table4.backgroundColor = [UIColor clearColor];
        UIImageView*image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Left"]];
        //去除cell的分割线
        table4.separatorStyle = UITableViewCellSeparatorStyleNone;
        table4.backgroundView = image;
        table4.showsVerticalScrollIndicator = NO;//滑动条
        [_lolView addSubview:table4];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == table1)
    {
        return tableArray1.count;
    }
    else if (tableView == table2)
    {
        return tableArray2.count;
    }
    else if (tableView == table3)
    {
        return tableArray3.count;
    }
    else if (tableView == _movieTable)
    {
        return _movieArray.count;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == _movieTable)
    {
        static NSString*moiveCell = @"Moviecell";
        MovieCell*cell = [tableView dequeueReusableCellWithIdentifier:moiveCell];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MovieCell" owner:self options:nil]lastObject];
        }
        
        cell.model = _movieArray[indexPath.row];
        
        return cell;
    }
    else
    {
        static NSString*startCell = @"Gamecell";
        GameViewCell *cell = [tableView dequeueReusableCellWithIdentifier:startCell];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"GameViewCell" owner:self options:nil] lastObject];
        }
    
        if (tableView == table1)
        {
            cell.model = tableArray1[indexPath.row];
            
        }
        else if (tableView == table2)
        {
            cell.model = tableArray2[indexPath.row];
        }
        else
        {
            cell.model = tableArray3[indexPath.row];
        }
        cell.backgroundColor = [UIColor clearColor];

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _movieTable) {
        return 100;
    }
    
    return 125;
}
#pragma mark - scroll的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _movieTable)
    {
        return;
    }
    NSArray*scrollArray = @[table1,table2,table3];
    for (UIScrollView*scroll in scrollArray)
    {   //如果遍历得到的scrollView不是正在滑动的scrollView，则改变它的移动位置
        if (scroll !=scrollView)
        {
            scroll.contentOffset = scrollView.contentOffset;
        }
    }
}
#pragma mark - 单元格的选中时间
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _movieTable) {
        
        MovieModel*model = _movieArray[indexPath.row];
        
        NSString *string=[NSString stringWithFormat:@"%@",model.vplay_url];
        NSString *urlString=string;
        MPMoviePlayerViewController *mpvc = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:urlString]];
        [self presentViewController:mpvc animated:YES completion:nil];
        
        return;
    }
    
    DetailGameController*detail = [[DetailGameController alloc] init];
    if (tableView == table1)
    {
        GameModel*model = tableArray1[indexPath.row];
        detail.gameID = model.gameID;
    }
    else if (tableView == table2)
    {
        GameModel*model = tableArray2[indexPath.row];
        detail.gameID = model.gameID;
    }
    else
    {
        GameModel*model = tableArray3[indexPath.row];
        detail.gameID = model.gameID;
    }
    [self.navigationController pushViewController:detail animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 
@end
