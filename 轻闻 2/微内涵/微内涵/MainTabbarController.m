//
//  MainTabbarController.m
//  微内涵
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "MainTabbarController.h"
#import "GameViewController.h"
#import "PicterViewController.h"
#import "VideoViewController.h"
#import "LoveViewController.h"
@interface MainTabbarController ()

@end

@implementation MainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PicterViewController *pc = [[PicterViewController alloc] init];
    UINavigationController*nav1 = [[UINavigationController alloc] initWithRootViewController:pc];
    
    GameViewController*game = [[GameViewController alloc] init];
    UINavigationController *nav2= [[UINavigationController alloc] initWithRootViewController:game];
    
    
    VideoViewController*video = [[VideoViewController alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:video];
    
    
    LoveViewController *love = [[LoveViewController alloc] init];
    UINavigationController*nav4 = [[UINavigationController alloc] initWithRootViewController:love];
    
    NSArray*title = @[@"新闻",@"视听",@"发现",@"阅读"];
    NSArray*numBtn = @[@"tabbar_icon_news_highlight@2x",@"tabbar_icon_media_highlight@2x",@"tabbar_icon_found_highlight@2x",@"tabbar_icon_reader_highlight@2x"];
    NSArray*selescBtn = @[@"tabbar_icon_news_normal@2x",@"tabbar_icon_media_normal@2x",@"tabbar_icon_found_normal@2x",@"tabbar_icon_reader_normal@2x"];
    
    
    NSArray*array = @[nav1,nav2,nav3,nav4];
    
    for (int i = 0; i<title.count; i++)
    {
        UINavigationController *nav = array[i];
    
        UITabBarItem*item = nav.tabBarItem;
        
        NSString*str = selescBtn[i];
        
        NSString*selectStr = numBtn[i];
        UIImage *selectImage = [UIImage imageNamed:selectStr];
      
        item.image = [UIImage imageNamed:str];
      
        item.selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.title = title[i];
        //设置tabbar按钮颜色
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],UITextAttributeTextColor, nil] forState:UIControlStateSelected];
        
         nav.navigationBar.barTintColor = [UIColor colorWithRed:206/255.0 green:33/255.0 blue:33/255.0 alpha:1];
    }
    
    self.viewControllers = array;
    
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
