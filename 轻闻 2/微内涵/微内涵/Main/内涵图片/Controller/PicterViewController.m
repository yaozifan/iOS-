//
//  PicterViewController.m
//  微内涵
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//
#define HAScrollItemIndex @"index"
#define BTNSCROLLOFF @"BTNSCROLLOFF"
#import "PicterViewController.h"
#import "AFNateWorking.h"
#import "LookModel.h"
#import "UIKit+AFNetworking.h"
#import "MJRefresh.h"
#import "LookDetailController.h"
#import "HACursor.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
@interface PicterViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSArray*titleArray;//分页的名字
    HACursor *cursor;
    NSArray*word;
    NSMutableArray*tableArray;
    UIView*bjView;//阴影效果
}
@end

@implementation PicterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新闻";
    tableArray = [[NSMutableArray alloc] init];
    UITableView*table = [[UITableView alloc] init];
    [self.view addSubview:table];
    //更换视图的时候通知改变页码
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNum:) name:HAScrollItemIndex object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNum:) name:BTNSCROLLOFF object:nil];
    //关闭阴影效果
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeBJview) name:@"close" object:nil];
    [self creatCursor];
    [self creatNavBtn];
}
//右上角的按钮
- (void)creatNavBtn
{
    UIButton*button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 addTarget:self action:@selector(leftBtn) forControlEvents:UIControlEventTouchUpInside];
    button1.titleLabel.font = [UIFont systemFontOfSize:17 weight:3];
    [button1 setImage:[UIImage imageNamed:@"LiftBtn"] forState:UIControlStateNormal];
    
    button1.frame = CGRectMake(10,5, 25, 25);
    
    UIBarButtonItem*item = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = item;
}
//打开左边视图
- (void)leftBtn
{
    if (bjView == nil)
    {
        bjView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        bjView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
        
        [self.view addSubview:bjView];
    }
    
    bjView.hidden = NO;
    
    MMDrawerController*mmd = self.mm_drawerController;
    
    [mmd openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
//关闭阴影效果
- (void)closeBJview
{
    bjView.hidden = YES;
    
}
 // code4APP--开源中国－－－setmentfout--
#pragma mark - 更换视图的时候通知改变页码
- (void)myNum:(NSNotification*)notification
{
    NSNumber*num = notification.object;
    
    _intNum = [num integerValue];
    
}

#pragma mark - 创建滑动导航栏
- (void)creatCursor {
    //不允许有重复的标题
    titleArray = @[@"精选",@"搞笑",@"科技",@"娱乐",@"旅游"];
    
    cursor = [[HACursor alloc]init];
    cursor.frame = CGRectMake(0, 64, self.view.width, 45);
    cursor.titles = titleArray;
    cursor.pageViews = [self createPageViews];
    //设置根滚动视图的高度
    cursor.rootScrollViewHeight = self.view.frame.size.height - 109;
    //默认值是白色
    cursor.titleNormalColor = [UIColor blackColor];
    //默认值是白色
    cursor.titleSelectedColor = [UIColor redColor];
    cursor.showSortbutton = NO;
    //默认的最小值是5，小于默认值的话按默认值设置
    cursor.minFontSize = 15;
    //默认的最大值是25，小于默认值的话按默认值设置，大于默认值按设置的值处理
    cursor.maxFontSize = 20;
    cursor.backgroundColor = [UIColor whiteColor];
    cursor.isGraduallyChangFont = NO;
    //在isGraduallyChangFont为NO的时候，isGraduallyChangColor不会有效果
    cursor.isGraduallyChangColor = YES;
    [self.view addSubview:cursor];
    [self showHud:@"精彩马上出现"];

}
#pragma mark-返回滑动导航栏的数组
- (NSMutableArray *)createPageViews{
    NSMutableArray *pageViews = [NSMutableArray array];
    
    word = @[@"精选",@"搞笑",@"经济",@"娱乐",@"旅游"];

    for (NSInteger i = 0; i < titleArray.count; i++)
    {
        LookTable*table = [[LookTable alloc] initWithFrame:CGRectMake(0, -40, KSCREENWIDTH, KSCREENHEIGHT) style:UITableViewStylePlain];
        //单元格分割线
        [table setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        
        [tableArray addObject:table];
        table.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
        table.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
        
        NSDictionary*dic = @{
                             @"num":@"20",
                             @"word":word[i]
                             };
        //传递参数，发送网络请求
        [self loadData:dic table:table];
        [pageViews addObject:table];
        
        
        //回调参数，跳转页面
        __weak PicterViewController* mySelf = self;
        
        [table setDetail:^(NSString*url){
           
            LookDetailController*detail = [[LookDetailController alloc] init];
            
            detail.detailUrl = url;
            __strong PicterViewController*pic = mySelf;
            
            [pic.navigationController pushViewController:detail animated:YES];
            
        }];
        
        [table setScrollDetail:^(NSString*url){
            LookDetailController*detail = [[LookDetailController alloc] init];
            
            detail.detailUrl = url;
            
            __strong PicterViewController*pic = mySelf;

            [pic.navigationController pushViewController:detail animated:YES];
            
        }];
        
    }
        return pageViews;
}
//访问网络请求的方法
- (void)loadData:(NSDictionary*)dic table:(LookTable*)table
{
    [AFNateWorking afNetWorking:@"http://apis.baidu.com/txapi/weixin/wxhot"
                         params:dic
                          metod:@"GET"
                completionBlock:^(id completion) {
                    NSMutableArray*tableArray = [[NSMutableArray alloc] init];
                    for (int i =0; i<20; i++)
                    {
                        NSString *STR = [NSString stringWithFormat:@"%d",i];
                        NSDictionary*dicID = completion[STR];
                        LookModel *model = [[LookModel alloc] init];
                        model.title = dicID[@"title"];
                        model.descriptionID = dicID[@"description"];
                        model.picUrl = dicID[@"picUrl"];
                        model.url = dicID[@"url"];
                        [tableArray addObject:model];
                    }
                    table.scrollArray = [tableArray subarrayWithRange:NSMakeRange(0, 5)];
                    
                    NSArray*array1 = [tableArray subarrayWithRange:NSMakeRange(5, 15)];
                    NSMutableArray*mutable = [[NSMutableArray alloc] init];
                    [mutable addObjectsFromArray:array1];
                    table.dataArray = mutable;
                   
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:self];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [table reloadData];
                        [self completeHUD:@"加载完毕"];
                    });

                }
                     errorBlock:^(NSError *error) {
                         NSLog(@"PicterView错误：%@",error);
                     }];
}
#pragma mark - 下拉刷新
- (void)_loadNewData
{
    LookTable*table = cursor.pageViews[_intNum];
    
    NSDictionary*dic = @{
                         @"num":@"20",
                         @"word":word[_intNum]
                         };

    [self loadData:dic table:table];
    [table.header endRefreshing];
}
#pragma mark - 上拉更多
- (void)_loadMoreData
{
   // NSLog(@"==%li",_intNum);
    
    LookTable*table = cursor.pageViews[_intNum];

    table.channel++;
    NSString*page = [NSString stringWithFormat:@"%li",table.channel+2];
    NSLog(@"%@",page);
    
    NSDictionary*dic = @{
                         @"num":@"10",
                         @"word":word[_intNum],
                         @"page":page
                         };
    
    [AFNateWorking afNetWorking:@"http://apis.baidu.com/txapi/weixin/wxhot"
                         params:dic
                          metod:@"GET"
                completionBlock:^(id completion) {
                  
                    if (completion != nil)
                    {
                        NSMutableArray*tableArray = [[NSMutableArray alloc] init];
                        for (int i =0; i<10; i++)
                        {
                            NSString *STR = [NSString stringWithFormat:@"%d",i];
                            NSDictionary*dicID = completion[STR];
                            LookModel *model = [[LookModel alloc] init];
                            model.title = dicID[@"title"];
                            model.descriptionID = dicID[@"description"];
                            model.picUrl = dicID[@"picUrl"];
                            model.url = dicID[@"url"];
                            [tableArray addObject:model];
                        }
                        
                        [table.dataArray addObjectsFromArray:tableArray];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [table reloadData];
                        });
                        
                    }
                    
                }
                     errorBlock:^(NSError *error) {
                         NSLog(@"%@",error);
                     }];
    [table.footer endRefreshing];

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除通知
}
//加入如下代码实现对齐cell分割线
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    for (LookTable*Ltable in tableArray) {
        
    if ([Ltable respondsToSelector:@selector(setSeparatorInset:)]) {
        [Ltable setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([Ltable respondsToSelector:@selector(setLayoutMargins:)]) {
        [Ltable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    }

}


@end
