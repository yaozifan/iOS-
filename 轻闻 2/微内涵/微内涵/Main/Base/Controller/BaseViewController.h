//
//  BaseViewController.h
//  微内涵
//
//  Created by mac on 15/10/23.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController
{
    MBProgressHUD *_hud;
}


- (void)completeHUD:(NSString*)title;

- (void)showHud:(NSString*)title;

- (void)hideHud;

/*
 [AFNateWorking afNetWorking:@"http://www.weather.com.cn/adat/sk/101210101.html"
 params:nil
 metod:@"GET"
 completionBlock:^(id completion) {
 
 NSLog(@"%@",completion);
 } errorBlock:^(NSError *error) {
 
 }];
 

 */
@end
