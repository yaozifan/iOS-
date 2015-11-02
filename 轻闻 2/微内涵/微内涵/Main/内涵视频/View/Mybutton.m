//
//  Mybutton.m
//  画板
//
//  Created by mac on 15/9/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "Mybutton.h"

@implementation Mybutton




- (void)drawRect:(CGRect)rect {
    //获得图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    
        //button为选中状态，则执行划红线的方法
        if (self.selected)
        {
        
            [self creatRed:context];
            self.titleLabel.font = [UIFont systemFontOfSize:20 weight:3];
       }
        else
        {
            self.titleLabel.font = [UIFont systemFontOfSize:17 weight:1];

        }

}

-(void)creatRed:(CGContextRef)context
{
    path=CGPathCreateMutable();
    //起始点
    CGPathMoveToPoint(path, nil, 0, self.bounds.size.height);
    CGPathAddLineToPoint(path, nil, self.bounds.size.width, self.bounds.size.height);
    //设置线条宽度等
    CGContextSetRGBStrokeColor(context, 1, 1,1, 1);
    CGContextSetLineWidth(context, 5);
    
    
    //路径加到图形上下文上
    CGContextAddPath(context, path);
    
    //绘制路径
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
    
    
}


@end
