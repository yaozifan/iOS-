//
//  DetailGameController.h
//  微内涵
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseViewController.h"

@interface DetailGameController : BaseViewController
@property (nonatomic,copy) NSString *gameID;


- (void)showHud:(NSString*)title;
- (void)hideHud;

@end
