//
//  GameModel.h
//  微内涵
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseModel.h"

@interface GameModel : BaseModel
/*
 "name": "最近更新",
 "url": "http://dotaly.com",
 "detail": "2015-10-20",
 "pop": -1,
 "youku_id": "none",
 "id": "all",
 "icon": "http://tp3.sinaimg.cn/2570873434/180/5661996247/1"
 */
//
@property (nonatomic,copy) NSString*name;
@property (nonatomic,copy) NSString*url;
//@property (nonatomic,copy) NSString*detail;
@property (nonatomic,copy) NSString*pop;
@property (nonatomic,copy) NSString*youku_id;
@property (nonatomic,copy) NSString*gameID;
@property (nonatomic,copy) NSString*icon;
//@property (copy,nonatomic) NSString *youku_id;
//@property (copy,nonatomic) NSString *wxID;
//@property (copy,nonatomic) NSString *icon;
//@property (copy,nonatomic) NSString *name;
//@property (copy,nonatomic) NSString *url;
//@property (copy,nonatomic) NSString *pop;
//
//
@end
