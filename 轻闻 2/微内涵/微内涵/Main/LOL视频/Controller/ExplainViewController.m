//
//  ExplainViewController.m
//  微内涵
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ExplainViewController.h"
#import <sqlite3.h>
@interface ExplainViewController ()
{
    NSString*_url;
    UIButton*rightBtn;//收藏按钮
}
@end

@implementation ExplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatButton];
    [self ifhaveSQL];
    [self loadData];
}

- (void)loadData
{
    
    NSString*detailID = _model.detailId;
    
    NSString *string = [NSString stringWithFormat:@"http://api.dotaly.com/lol/api/v1/getvideourl?iap=0&ident=1EFB14A9-BC26-497D-A761-D2DE836C3933&jb=0&nc=3435719118&tk=55b9a53452e4994c8e2d83a9207c671d&type=flv&vid=%@",detailID];
      [AFNateWorking afRequestData:string
                        HTTPMethod:@"GET"
                            parame:nil
                        completion:^(id completion) {
                           
                            [self creatImageView];
                            _url = completion[@"url"];
                        } errorBlock:^(NSError *error) {
                            
                        }];
    
}
- (void)creatButton
{
    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbtn.frame = CGRectMake(0, 0, 40, 30);
    [leftbtn setTitle:@"返回" forState:UIControlStateNormal];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
    [leftbtn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    leftbtn.tag = 10;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 80, 30);
    [rightBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*right = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = right;
    
}
#pragma mark- 进入页面 即判断是否有数据x
- (BOOL)ifhaveSQL
{
    NSString*filePath = [self filepath];

    //定义数据库句柄
    sqlite3*DBhandle = nil;
    int result = sqlite3_open([filePath UTF8String], &DBhandle);
    if (result != SQLITE_OK)
    {
        NSLog(@"数据库打开失败");
        return NO;
    }
    //构造sql语句 ,判断数据库中是否有这个标题的页面
    NSString*querySQL =@"SELECT * FROM game WHERE title=?";
    //预编译
    sqlite3_stmt*stmt = NULL;
    sqlite3_prepare_v2(DBhandle, [querySQL UTF8String], -1, &stmt, NULL);
    //向占位符上绑定数据
    sqlite3_bind_text(stmt, 1, [_model.title UTF8String], -1, NULL);
    //执行数据库操作
    int hasData = sqlite3_step(stmt);
    
    if (hasData == SQLITE_ROW)//当前行是否有数据
    {
        [rightBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
        sqlite3_close(DBhandle);
        sqlite3_finalize(stmt);//释放预编译后的句柄，，结构体内存
        return YES;
    }
    sqlite3_close(DBhandle);
    sqlite3_finalize(stmt);//释放预编译后的句柄，，结构体内存
    return NO;
}

#pragma mark - 收藏
- (void)clickRightBtn
{
    if ([rightBtn.titleLabel.text isEqualToString:@"收藏"])
    {    //向数据库中添加数据
        [self insertDetailModel:_model];
    }
    else
    {
        //移除数据
        [self removieSQL];
    }
    
    
}
//打开数据库文件
- (NSString*)filepath
{
    NSString*filePath = [NSHomeDirectory()stringByAppendingFormat:@"/Documents/%@",@"gameDetail.rdb"];
    return filePath;
}
//删除数据
- (void)removieSQL
{
    NSString*filePath = [self filepath];
    
    //定义数据库句柄
    sqlite3*DBhandle = nil;
    int result = sqlite3_open([filePath UTF8String], &DBhandle);
    if (result != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return ;
    }
    //构造sql语句 ,删除数据库中有这个标题的数据
    NSString*querySQL =@"DELETE FROM game WHERE title=?";
  //  NSString*querySQL =@"DELETE * FROM game";
    
    //预编译
    sqlite3_stmt*stmt = NULL;
     result = sqlite3_prepare_v2(DBhandle, [querySQL UTF8String], -1, &stmt, NULL);
   
    if (result != SQLITE_OK) {
        NSLog(@"Error: failed to delete:testTable");
        sqlite3_close(DBhandle);
        return ;
    }
    //向占位符上绑定数据
    sqlite3_bind_text(stmt, 1, [_model.title UTF8String], -1, NULL);
    //执行数据库操作,更新数据库
    result = sqlite3_step(stmt);
    //如果执行失败
    if (result == SQLITE_ERROR) {
        NSLog(@"Error: failed to delete the database with message.");
        //关闭数据库
        sqlite3_close(DBhandle);
        return ;
    }

    sqlite3_close(DBhandle);
    sqlite3_finalize(stmt);//释放预编译后的句柄，，结构体内存

    [rightBtn setTitle:@"收藏" forState:UIControlStateNormal];
    
}
//向数据库插入文件
- (BOOL)insertDetailModel:(DetailModel*)model
{
    
    if (![self ifhaveSQL])
    {
        static NSInteger a;
        a++;
        
        NSString*filePath = [self filepath];
        //定义数据库句柄
        sqlite3 *handle = NULL;
        int resulet = sqlite3_open([filePath UTF8String], &handle);
        
        if (resulet != SQLITE_OK)
        {
            NSLog(@"打开失败");
            return NO;
        }
        //构造sqlite语句
        NSString*insertSQL = @"INSERT INTO game(title,time,date,thumb,num,detailId) VALUES(?,?,?,?,?,?)";
        //预编译操作
        sqlite3_stmt *stmt = NULL;
        resulet = sqlite3_prepare_v2(handle, [insertSQL UTF8String], -1, &stmt, NULL);
        
        if (resulet != SQLITE_OK) {
            
            NSLog(@"预编译失败");
            
            sqlite3_close(handle);
            
            return NO;
        }
        
        //向占位符上填充数据
        sqlite3_bind_text(stmt, 1, [model.title UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 2, [model.time UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 3, [model.date UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 4, [model.thumb UTF8String], -1, nil);
        sqlite3_bind_int64(stmt, 5,a);
        sqlite3_bind_text(stmt, 6, [model.detailId UTF8String], -1, nil);
        
        //执行sql语句
        resulet = sqlite3_step(stmt);
        if (resulet != SQLITE_DONE)
        {
            NSLog(@"插入数据失败");
            //关闭句柄
            sqlite3_close(handle);
            sqlite3_finalize(stmt);//释放预编译后的句柄，，结构体内存
            return NO;
        }
        //重新初始化预编译句柄后的句柄和绑定的变量，准备插入下一条数据
        sqlite3_reset(stmt);
        //关闭数据库句柄
        sqlite3_close(handle);
        sqlite3_finalize(stmt);//释放预编译后的句柄，，结构体内存
        
        [rightBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
        return YES;
    }
    
    UIAlertView*alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已收藏" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
    return NO;
    
    
}
//返回按钮
- (void)clickLeftBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
//播放按钮
- (void)creatImageView
{
    UIButton*btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnImage.frame = CGRectMake(10, 74, KSCREENWIDTH-20, (KSCREENHEIGHT-64)/2);
    
    [btnImage addTarget:self action:@selector(playMovie) forControlEvents:UIControlEventTouchUpInside];
    
    [btnImage setImage:[UIImage imageNamed:@"PlayMovie"] forState:UIControlStateNormal];
    
    if (_model.thumb!=nil) {
        
        [btnImage setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:_model.thumb] placeholderImage:[UIImage imageNamed:@"UseCenterWeatherBGRain"]];
    }

    [self.view addSubview:btnImage];
}

- (void)playMovie
{
    MPMoviePlayerViewController *mpvc = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:_url]];
    [self presentViewController:mpvc animated:YES completion:nil];
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
