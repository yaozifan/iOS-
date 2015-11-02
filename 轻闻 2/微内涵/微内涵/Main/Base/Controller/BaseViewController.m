//
//  BaseViewController.m
//  微内涵
//
//  Created by mac on 15/10/23.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController ()
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - 菊花
- (void)showHud:(NSString*)title;
{
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.dimBackground = YES;//灰色背景视图
    }
    [_hud show:YES];
}
- (void)hideHud;
{
    [_hud hide:YES];
}

- (void)completeHUD:(NSString*)title
{
    _hud.mode = MBProgressHUDModeCustomView;
    
    _hud.labelText = title;
    
    //持续1.5秒隐藏
    [_hud hide:YES afterDelay:1.5];
    
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
