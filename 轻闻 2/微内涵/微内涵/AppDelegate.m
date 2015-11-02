//
//  AppDelegate.m
//  微内涵
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabbarController.h"
#import "MMDrawerController.h"
#import "LeftViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "UMSocial.h"
#import <sqlite3.h>
#import "UMSocialSinaHandler.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    [UMSocialData setAppKey:@"507fcab25270157b37000010"];
  
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //集成MMDrawer
    [self creatMMDrawer];

    //[self isFirst];
    return YES;
}

- (BOOL)isFirst
{
    //判断是否第一次运行
    NSUserDefaults*userFaults = [NSUserDefaults standardUserDefaults];
    //通过一个key,寻找一个值，如果没有找到此值，返回no
    BOOL first = [userFaults objectForKey:@"first"];
    if (!first)
    {
        
        //创建收藏数据库文件
        //打开数据库文件
        NSString*filePath = [NSHomeDirectory()stringByAppendingFormat:@"/Documents/%@",@"gameDetail.rdb"];
        
        NSLog(@"%@",filePath);
        //定义数据库句柄
        sqlite3 *handle = NULL;
        int resulet = sqlite3_open([filePath UTF8String], &handle);
        
        if (resulet != SQLITE_OK)
        {
            NSLog(@"打开失败");
            return NO;
        }
        //构造一个SQL语句
        NSString*creatSQL = @"CREATE TABLE game(title text,time text,date text,thumb text,num integer,detailId text)";
        
        //执行SQL语句
        char*error = nil;
        resulet = sqlite3_exec(handle, [creatSQL UTF8String], NULL, NULL, &error);
        if (resulet != SQLITE_OK)
        {
            NSLog(@"打开数据库失败%s",error);
            return NO;
        }
        
        //关闭数据库
        sqlite3_close(handle);
        
        return YES;

    }
    return YES;
}

- (void)creatMMDrawer
{   //左中右控制器
    MainTabbarController*main = [[MainTabbarController alloc] init];
    LeftViewController*left = [[LeftViewController alloc] init];
    
    //创建MMDrawer
    MMDrawerController *mmd = [[MMDrawerController alloc] initWithCenterViewController:main leftDrawerViewController:left];
    
    //设置左右两边显示的宽度
    [mmd setMaximumLeftDrawerWidth:300];
    
    //设置手势有效区域
    [mmd setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [mmd setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    //设置动画类型
    [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeSwingingDoor];
    [[MMExampleDrawerVisualStateManager sharedManager] setRightDrawerAnimationType:MMDrawerAnimationTypeSwingingDoor];
    
    //设置动画效果，当左右侧边栏打开或者关闭的时候执行该block内的代码
    [mmd
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    self.window.rootViewController = mmd;
     //添加启动界面动画
    UIImageView *startImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,KSCREENWIDTH, KSCREENHEIGHT)];
    
    startImageView.image = [UIImage imageNamed:@"1.png"];
    [mmd.view addSubview:startImageView];
    
    [UIView animateWithDuration:0 animations:^{
        startImageView.alpha = 1;
    }];
    [UIView animateWithDuration:4 animations:^{
        startImageView.alpha = 0;
    }];
    
    
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}
@end
