//
//  ColletionViewController.m
//  微内涵
//
//  Created by mac on 15/10/29.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ColletionViewController.h"
#import "DetailModel.h"
#import "DetailGameCell.h"
#import <sqlite3.h>
#import "ExplainViewController.h"
@interface ColletionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray*_dataArray;
}
@end

@implementation ColletionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
   
    self.title = @"收藏列表";
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:206/255.0 green:33/255.0 blue:33/255.0 alpha:1];
        [self loadData];
        
        [self creatTable];
    
}

//读取数据库内的收藏数据
- (NSArray*)loadData
{
    //打开数据库
    NSString*filePath = [NSHomeDirectory()stringByAppendingFormat:@"/Documents/%@",@"gameDetail.rdb"];
    //定义数据库句柄
    sqlite3*DBhandle = nil;
    int result = sqlite3_open([filePath UTF8String], &DBhandle);
    if (result != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    //构造sql语句
    NSString*querySQL =@"SELECT * FROM game WHERE num>?";
    //预编译
    
    sqlite3_stmt*stmt = NULL;
    sqlite3_prepare_v2(DBhandle, [querySQL UTF8String], -1, &stmt, NULL);
    //向占位符上绑定数据
    int num = 0;
    sqlite3_bind_int(stmt, 1, num);
    //执行数据库操作
    int hasData = sqlite3_step(stmt);
    
    while (hasData == SQLITE_ROW)//当前行是否有数据
    {        
        //取出游标指向的行数据  title,time,date,thumb
              const unsigned char *title = sqlite3_column_text(stmt, 0);
              const unsigned char *time = sqlite3_column_text(stmt, 1);
              const unsigned char *date = sqlite3_column_text(stmt, 2);
              const unsigned char *thumb = sqlite3_column_text(stmt, 3);
              const unsigned char *detailId = sqlite3_column_text(stmt, 5);

        //填充查询到的行数据到model中
        DetailModel*model = [[DetailModel alloc] init];
        
        model.title = [NSString stringWithCString:(const char*)title encoding:NSUTF8StringEncoding];
        model.time = [NSString stringWithCString:(const char*)time encoding:NSUTF8StringEncoding];
        model.date = [NSString stringWithCString:(const char*)date encoding:NSUTF8StringEncoding];
        model.thumb = [NSString stringWithCString:(const char*)thumb encoding:NSUTF8StringEncoding];
        model.detailId = [NSString stringWithCString:(const char*)detailId encoding:NSUTF8StringEncoding];
        [_dataArray addObject:model];
        //让游标继续向下一行行走，再判断当前行是否有数据
        hasData = sqlite3_step(stmt);

    }
    
    return _dataArray;
}

- (void)creatTable
{
    UITableView*table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, KSCREENHEIGHT) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    
    UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:@"返回" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = item;
    [self.view addSubview:table];
}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailGameCell*cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailGameCell" owner:self options:nil]lastObject];
    }
    
    
    cell.model = _dataArray [indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExplainViewController*explain = [[ExplainViewController alloc] init];
    
    explain.model = _dataArray[indexPath.row];

    [self.navigationController pushViewController:explain animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
