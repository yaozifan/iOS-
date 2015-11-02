//
//  VideoViewController.m
//  微内涵
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoModel.h"
#import "VideoCell.h"
#import "ContentCell.h"
#import "Mybutton.h"
@interface VideoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView*pictureView;
    UIView*contentView;
    int _page;
    NSString*_timeString;
    NSMutableArray *_dataArray;
    NSMutableArray*_dataArray2;
    Mybutton*button;
    Mybutton*button1;
    UITableView*_pictureTable;
    UITableView*_contentTable;
    int _time;
}
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _page = 1;
    //获取系统当前的时间戳
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970];
    _timeString=[NSString stringWithFormat:@"%f",a];
     _time=_timeString.intValue;

    _dataArray = [[NSMutableArray alloc] init];
    _dataArray2 = [[NSMutableArray alloc] init];
    [self creatNavView];
    [self creatView];
    [self loadData:QUTU_URL];
    [self loadData:NEIHAN_URL];
    //下滑隐藏导航栏
    self.navigationController.hidesBarsOnSwipe = YES;
    
}
#pragma mark - 切换视图
- (void)creatNavView
{
    button = [Mybutton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(btnPicter) forControlEvents:UIControlEventTouchUpInside];
    button.selected = YES;
    
    [button setTitle:@"趣图" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17 weight:3];
    button.frame = CGRectMake(0, 0, KSCREENWIDTH/2, 25);
    
    button1 = [Mybutton buttonWithType:UIButtonTypeCustom];
    [button1 addTarget:self action:@selector(btnContent) forControlEvents:UIControlEventTouchUpInside];
    button1.titleLabel.font = [UIFont systemFontOfSize:17 weight:3];
    [button1 setTitle:@"趣闻" forState:UIControlStateNormal];
    button1.frame = CGRectMake(KSCREENWIDTH/2,0, KSCREENWIDTH/2, 25);
    
    UIBarButtonItem*item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    UIBarButtonItem*item1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = item1;

}
#pragma mark- 点击翻转视图
- (void)btnPicter
{
    if (pictureView.hidden == NO) {
        return;
    }
    button.selected = YES;
    button1.selected = NO;
    [UIView transitionWithView:self.view
                      duration:.3
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        contentView.hidden = YES;
                        pictureView.hidden = NO;
                    } completion:nil];
}

- (void)btnContent
{
    if (contentView.hidden == NO) {
        return;
    }
    button.selected = NO;
    button1.selected = YES;
    [UIView transitionWithView:self.view
                      duration:.3
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        contentView.hidden = NO;
                        pictureView.hidden = YES;

                    } completion:nil];
    
}

#pragma mark - 建立两个翻转视图
- (void)creatView
{
    pictureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, KSCREENHEIGHT)];
    pictureView.backgroundColor = [UIColor whiteColor];
    _pictureTable =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, KSCREENHEIGHT-40) style:UITableViewStylePlain];
    _pictureTable.delegate = self;
    _pictureTable.dataSource = self;
    _pictureTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    _pictureTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
    [pictureView addSubview:_pictureTable];
    [self.view addSubview:pictureView];
    
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, KSCREENHEIGHT)];
    contentView.backgroundColor = [UIColor whiteColor];
    UIImage*image = [UIImage imageNamed:@"Content.jpg"];
    UIImageView*view = [[UIImageView alloc] initWithImage:image];
    view.frame = CGRectMake(0, 0, KSCREENWIDTH, 64);
    
    _contentTable =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, KSCREENHEIGHT-40) style:UITableViewStylePlain];
    _contentTable.delegate = self;
    _contentTable.dataSource = self;
    _contentTable.backgroundColor = [UIColor clearColor];
    [contentView addSubview:_contentTable];
    _contentTable.tableHeaderView = view;
    [self.view addSubview:contentView];
     contentView.hidden = YES;
    
}
- (void)_loadNewData
{
    //从第一页开始下载
    _page = 1;
    //重新下载数据
    _time=_timeString.intValue;
    
    [self loadData:QUTU_URL];
    //结束下拉刷新
    [_pictureTable.header endRefreshing];
}
- (void)_loadMoreData
{    _page += 1;
    //下载下一页数据
    //    60   一分种
    _time=_timeString.intValue-3600*_page*24;
    [self loadData:QUTU_URL];
    //结束上拉加载更多
    [_pictureTable.footer endRefreshing];
}
- (void)loadData:(NSString*)url
{
    NSString *urlString = [NSString stringWithFormat:url,_page,_time];
    NSLog(@"%d",_page);
    
    [AFNateWorking afNetWorking:urlString
                         params:nil
                          metod:@"GET"
                completionBlock:^(id completion) {
                    //NSLog(@"%@",completion);
                    NSArray*items = completion[@"items"];
                    NSMutableArray*array = [[NSMutableArray alloc] init];
                   
                    if ([url isEqualToString:QUTU_URL])
                    {
                        
                        for (NSDictionary*dic in items)
                        {
                            VideoModel*model = [[VideoModel alloc] initWithDataDic:dic];
                            
                            [array addObject:model];
                        }
                        
                        [_dataArray addObjectsFromArray:array];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_pictureTable reloadData];
                        });
                    }
                    else if ([url isEqualToString:NEIHAN_URL])
                    {
                        for (NSDictionary*dic in items)
                        {
                            VideoModel*model = [[VideoModel alloc] initWithDataDic:dic];
                            
                            [array addObject:model];
                        }
                        
                        [_dataArray2 addObjectsFromArray:array];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_contentTable reloadData];
                        });

                    }
                } errorBlock:^(NSError *error) {
                    
                }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _pictureTable)
    {
        return _dataArray.count;
    }
    else if (tableView == _contentTable)
    {
        return _dataArray2.count;
    }
    return 0 ;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString*indexCell = @"cell";

    if (tableView == _pictureTable)
    {
    
        VideoCell*cell = [tableView dequeueReusableCellWithIdentifier:indexCell];
        
        if (cell == nil) {
            
            cell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indexCell];
        }
        
        cell.model = _dataArray[indexPath.row];
        cell.wpic_middleImageView.frame = CGRectMake(10,40, KSCREENWIDTH-20, cell.model.wpic_m_height.intValue);
        return cell;
    }
    else if (tableView == _contentTable)
    {
        ContentCell*cell = [tableView dequeueReusableCellWithIdentifier:indexCell];
        
        if (cell == nil)
        {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ContentCell" owner:self options:nil]lastObject ];
        }
        cell.model = _dataArray2[indexPath.row];
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Content.jpg"]];
        return cell;
    }
    return nil;
}

#pragma mark 改表格视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _pictureTable)
    {
        VideoModel *model=_dataArray[indexPath.row];
        return model.wpic_m_height.intValue+80;
    }
    else if (tableView == _contentTable)
    {
        VideoModel*model = _dataArray2[indexPath.row];
        
        NSString*str = model.wbody;
        NSDictionary*dic = @{
                             NSFontAttributeName:[UIFont systemFontOfSize:16],
                             
                             };
        
        CGSize maxSize = CGSizeMake(tableView.bounds.size.width, CGFLOAT_MAX);
        CGRect size = [str boundingRectWithSize:maxSize
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:dic
                                        context:nil];
        CGFloat height = size.size.height;
        return height+100;
    }
    return 0;
    
}



@end
