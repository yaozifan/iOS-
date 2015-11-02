//
//  GameModel.m
//  微内涵
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel

- (NSDictionary*)attributeMapDictionary
{
    //   @"属性名": @"数据字典的key"

    NSDictionary*map = @{
               @"gameID":@"id"
                         };
    
    return map;
}


@end
