//
//  DetailModel.m
//  微内涵
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "DetailModel.h"

@implementation DetailModel

//- (NSDictionary*)attributeMapDictionary
//{
//    NSDictionary*map = @{
//                        @"author":@"author",
//                        @"thumb":@"thumb",
//                        @"title":@"title",
//                        @"time":@"time",
//                        @"date":@"date",
//                       @"detailId":@"id"
//                         };
//    
//    return map;
//}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.detailId = value;
    }
    
}


@end
