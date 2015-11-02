//
//  LeftViewController.m
//  微内涵
//
//  Created by mac on 15/10/27.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "LeftViewController.h"
#import "AFNateWorking.h"
#import "UMSocial.h"
#import "UIImageView+AFNetworking.h"
#import "SDImageCache.h"
#import "ColletionViewController.h"
@interface LeftViewController ()<UMSocialUIDelegate,UIAlertViewDelegate>
{
    UIImageView*userView;
    UILabel*userLable;
    BOOL _isSelected;
    UIButton*_loginButton;
    UILabel*cacheLable;
    UIAlertView *cacheAlertView;
}
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
  //  [self loadData];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"weiBJUI.jpg"]];
    [self creatBtn];
}

- (void)loadData
{
    [AFNateWorking afNetWorking:@"http://www.weather.com.cn/adat/sk/101210101.html"
                         params:nil
                          metod:@"GET"
                completionBlock:^(id completion) {
        
                    NSLog(@"%@",completion);
                    
                   } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 创建按钮
- (void)creatBtn
{
    NSArray *buttonArr = @[@"收藏",@"反馈",@"关于",@"分享",@"清理内存"];
   
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginButton.frame = CGRectMake(60, 300, 150, 50);

    [_loginButton addTarget:self action:@selector(loginBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_loginButton];
    
    for (int i = 0; i<buttonArr.count; i++)
    {
        UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(60, 350+i*50, 150, 50);
        [button setTitle:buttonArr[i] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.view addSubview:button];
    }
    
    cacheLable = [[UILabel alloc] initWithFrame:CGRectMake(105, 570, 150, 50)];
    
    NSString*str=[NSString stringWithFormat:@"(%.2fMB)",[self countCacheFileSize]];
    cacheLable.text = str;
    cacheLable.font = [UIFont systemFontOfSize:15];
    cacheLable.textColor = [UIColor whiteColor];
    [self.view addSubview:cacheLable];
    userView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 200, 50, 50)];
    
    userView.image = [UIImage imageNamed:@"head"];
    
    userLable = [[UILabel alloc] initWithFrame:CGRectMake(110, 270, 60, 20)];
    
    [self.view addSubview:userLable];
    [self.view addSubview:userView];
    NSUserDefaults *username = [NSUserDefaults standardUserDefaults];
    NSUserDefaults *iconURL = [NSUserDefaults standardUserDefaults];
    if (![username objectForKey:@"username"]){
      
        userView.image = [UIImage imageNamed:@"head@2x.png"];
        [_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
        _isSelected = NO;
    }
    else{
        userLable.text = [username objectForKey:@"username"];
        [userView setImageWithURL:[NSURL URLWithString:[iconURL objectForKey:@"iconURL"]]];
        
        _isSelected = YES;
        [_loginButton setTitle:@"退出" forState:UIControlStateNormal];
    }
}

#pragma mark- 登陆的方法
- (void)loginBtn
{
    if (_isSelected == NO)
    {
        
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            //          获取微博用户名、uid、token等
            //            NSLog(@"%@",response.data);
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                
//                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                
                NSUserDefaults *userName = [NSUserDefaults standardUserDefaults];
                [userName setObject:snsAccount.userName forKey:@"username"];
                
                NSUserDefaults *iconURL = [NSUserDefaults standardUserDefaults];
                [iconURL setObject:snsAccount.iconURL forKey:@"iconURL"];
                
                if (![userName objectForKey:@"username"]) {
                    
                    userLable.text = @"请登录";
                    userView.image = [UIImage imageNamed:@"head"];
                    
                }
                else
                {
                    userLable.text = [userName objectForKey:@"username"];
                    [userView setImageWithURL:[NSURL URLWithString:[iconURL objectForKey:@"iconURL"]]];
                    
                    _isSelected = YES;
                    
                    [_loginButton setTitle:@"退出" forState:UIControlStateNormal];
                    return ;
                    
                }
                
            }});
    }
    else
    {
        UIAlertView*view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [view show];
    }
}
#pragma mark -alertView的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (alertView == cacheAlertView)
    {    //清除缓存
        if (buttonIndex == 0)
        {
            NSFileManager *manger = [NSFileManager defaultManager];
            
            NSString*homePath = NSHomeDirectory();
            
            NSArray*array = @[
                              @"/Library/Caches/xxx.---fsCachedData",                                         @"/Library/Caches/com.hackemist.SDWebImageCache.default",
                              ];
            for (NSString *string in array)
            {
                NSString *filePath=[NSString stringWithFormat:@"%@%@",homePath,string];
                
                [manger removeItemAtPath:filePath error:nil];
            }
            NSString*str=[NSString stringWithFormat:@"(%.2fMB)",[self countCacheFileSize]];
            cacheLable.text = str;
        }
    }
    else if(buttonIndex == 0)
    {
        NSUserDefaults *username = [NSUserDefaults standardUserDefaults];
        NSUserDefaults*iconURL = [NSUserDefaults standardUserDefaults];
        [username removeObjectForKey:@"username"];
        [iconURL removeObjectForKey:@"iconURL"];
        
        userView.image = [UIImage imageNamed:@"head"];
        userLable.text = nil;
        [_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
        _isSelected = NO;
    }
}

#pragma mark - 其他按钮的选中方法
- (void)selectButton:(UIButton*)btn
{
    if (btn.tag == 0)
    {
        ColletionViewController*collect = [[ColletionViewController alloc] init];
        
        UINavigationController*nav = [[UINavigationController alloc] initWithRootViewController:collect];
        
        [self presentViewController:nav animated:YES completion:nil];
    }
    else if (btn.tag == 1)
    {
        NSString*title = @"反馈";
        NSString*message = @"有好的建议或者发现程序BUG可发邮件到252937364@qq.com或520longgang@163.com";
        [self title:title message:message];
        
    }
    else if (btn.tag == 2)
    {
        NSString*title = @"关于";
        NSString*message = @"本应用是不含广告的1.0版本,其中可能有不可预知的BUG,本应用视频播放建议在Wi-Fi环境下使用";
        [self title:title message:message];

        
    }
    else if (btn.tag == 3)//分享
    {
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"507fcab25270157b37000010"
                                          shareText:@"我发现一款叫做“轻闻”的app，快来看看吧"
                                         shareImage:[UIImage imageNamed:@"icon.png"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,UMShareToWechatSession,UMShareToSms,UMShareToEmail,UMShareToFacebook,UMShareToTencent,nil]
                                           delegate:self];
    }
    else if (btn.tag == 4)
    {
        [self clearTmpPics];
    }
}

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

- (void)title:(NSString*)title message:(NSString*)message
{
    UIAlertView*alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -清除缓存的方法
- (void)clearTmpPics
{
    cacheAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定清除缓存？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [cacheAlertView show];
}

#pragma mark-获取文件夹路径
-(CGFloat)countCacheFileSize
{
    //获取缓存文件夹的路径
    //获取沙盒路径
    NSString *homePath=NSHomeDirectory();
  //  NSLog(@"%@",homePath);
    NSArray*array=@[ @"/Library/Caches/xxx.---fsCachedData",                                         @"/Library/Caches/com.hackemist.SDWebImageCache.default",
                     ];
    CGFloat fileSize=0;
    
    for (NSString *string in array) {
        
        NSString *filePath=[NSString stringWithFormat:@"%@%@",homePath,string];
        fileSize +=[self getFileSize:filePath];
    }
    return fileSize;
}


-(CGFloat)getFileSize:(NSString *)filePath
{
    //文件管理对象 单例
    NSFileManager *manager=[NSFileManager defaultManager];
    
    //数组 储存文件夹中所有的子文件以及文件的名字
    NSArray *fileNames=[manager subpathsOfDirectoryAtPath:filePath error:nil];
    
    long long size=0;
    
    //遍历文件夹
    for (NSString *fileName in fileNames) {
        
        NSString *subFilePath=[NSString stringWithFormat:@"%@%@",filePath,fileName];
        
        //获取文件信息
        NSDictionary *dic=[manager attributesOfItemAtPath:subFilePath error:nil];
        //获取单个文件的大小
        NSNumber *sizeNumber=dic[NSFileSize];
        
        long long subFileSize=[sizeNumber longLongValue];
        //文件夹大小求和
        size +=subFileSize;
    }
    return size/1024.0/1024;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString*str=[NSString stringWithFormat:@"(%.2fMB)",[self countCacheFileSize]];
    
    cacheLable.text=str;
}


@end
