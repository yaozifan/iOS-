//
//  UIView+Navigation.m
//  微内涵
//
//  Created by mac on 15/10/29.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "UIView+Navigation.h"

@implementation UIView (Navigation)

- (UIViewController*)viewController
{
    UIResponder *responder = self.nextResponder;
    while (responder != nil)
    {
        if ([responder isKindOfClass:[UIViewController class]])
        {
        
            return (UIViewController*)responder;
            
        }
        responder = responder.nextResponder;
    }
    return nil;
}

@end
