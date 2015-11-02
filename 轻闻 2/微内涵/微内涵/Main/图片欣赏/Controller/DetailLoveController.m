//
//  DetailLoveController.m
//  微内涵
//
//  Created by mac on 15/10/23.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "DetailLoveController.h"

@interface DetailLoveController ()

@end

@implementation DetailLoveController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
 }


- (void)viewWillAppear:(BOOL)animated
{
    UIWebView*web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSString*str = _loveid;
    
    NSURLRequest*reuqest = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    
    [web loadRequest:reuqest];
    
    [self.view addSubview:web];
    
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
