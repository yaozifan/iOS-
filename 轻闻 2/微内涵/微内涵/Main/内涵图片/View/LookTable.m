//
//  LookTable.m
//  微内涵
//
//  Created by mac on 15/10/24.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "LookTable.h"
#import "LookTableCell.h"

@interface  LookTable ()<UIScrollViewDelegate>
{
    UIScrollView*_scrollView;
    UIPageControl*_page;
    NSMutableArray*_dataArray;
    UILabel*_titleLable;
    UILabel*lable;
    NSMutableArray*textArray;
    int ki;
}

@end
@implementation LookTable

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        
        
        
        self.delegate = self;
        self.dataSource = self;
        UINib *nib = [UINib nibWithNibName:@"LookTableCell" bundle:[NSBundle mainBundle]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(push) name:@"change" object:nil];
        [self registerNib:nib forCellReuseIdentifier:@"LookCell"];
        [self creatScrollView];
        
        
    }
    
    return self;
}

#pragma mark - 滑动视图
- (void)creatScrollView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, 200)];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:view.bounds];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"284338"]];
    _scrollView.contentSize = CGSizeMake(KSCREENWIDTH*5, 200);
    _scrollView.bounces = NO;//关闭反弹效果
    //添加单机手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushDetailWebView:)];
    [_scrollView addGestureRecognizer:tap];

    _page=[[UIPageControl alloc]initWithFrame:CGRectMake(0,150 , KSCREENWIDTH, 30)];
    //设置PageControl的圆钮个数
    _page.numberOfPages=5;
    //设置page当前所在的位置
    _page.currentPage=0;
    //选中的圆钮的颜色
    _page.currentPageIndicatorTintColor=[UIColor whiteColor];
    //未选中的按钮的颜色
    _page.pageIndicatorTintColor=[UIColor grayColor];
    
    UIView*bgView = [[UIView alloc] initWithFrame:CGRectMake(0, view.bounds.size.height-30, KSCREENWIDTH, 30)];
    lable = [[UILabel alloc] initWithFrame:bgView.bounds];
    bgView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.5];
    lable.textColor = [UIColor blackColor];
    [bgView addSubview:lable];
    
    lable.textColor = [UIColor blackColor];
    [view addSubview:_scrollView];
    [view addSubview:_page];
    [view addSubview:bgView];
    
    self.tableHeaderView = view;
    
    NSTimer*time = [NSTimer timerWithTimeInterval:2.5 target:self selector:@selector(automatic:) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:time forMode:NSDefaultRunLoopMode];
}
//scrollView定时移动
- (void)automatic:(NSTimer*)time
{
    ki++;
    
    if (ki >=5) {
        ki = 0;
    }
    CGFloat automaticX = 375*ki;
    [_scrollView setContentOffset:CGPointMake(automaticX, 0) animated:YES];
    
    _page.currentPage=ki;
    lable.text = textArray[ki];
}
#pragma mark- 点击scrollView的手势的方法
- (void)pushDetailWebView:(UITapGestureRecognizer*)tap
{
     CGFloat x = _scrollView.contentOffset.x;
     int page = x/KSCREENWIDTH;
    
     LookModel*model = _scrollArray[page];
    
     NSString*url = model.url;
    
    _scrollDetail(url);
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LookTableCell*cell = [tableView dequeueReusableCellWithIdentifier:@"LookCell" forIndexPath:indexPath];
    
    cell.model = _dataArray[indexPath.row];
    
    return cell;
}

#pragma mark- 结束减速
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取最终的偏移量
    CGFloat offX=scrollView.contentOffset.x;
    //计算当前的页数
    NSInteger intex=offX/KSCREENWIDTH;
    //修改pageControl的currentPage
    _page.currentPage=intex;
    
    lable.text = textArray[intex];
}

- (void)push
{
    textArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++)
    {
        LookModel*model = _scrollArray[i];

        NSString*str = model.picUrl;
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(i*KSCREENWIDTH, 0, KSCREENWIDTH, 380)];
        image.contentMode = UIViewContentModeScaleToFill;
        [image setImageWithURL:[NSURL URLWithString:str]placeholderImage:[UIImage imageNamed:@"284338"]];
        
        NSString*text = [NSString stringWithFormat:@" %@",model.title];
        [textArray addObject:text];
        
        [_scrollView addSubview:image];
    }
    lable.text = textArray[0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除通知
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LookModel*model = _dataArray[indexPath.row];
    
    NSString*url = model.url;
    
    _detail(url);
    
}


@end
