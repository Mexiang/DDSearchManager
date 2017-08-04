//
//  DDSearchManager.h
//  MapNavTest
//
//  Created by Dry on 2017/1/14.
//  Copyright © 2017年 Dry. All rights reserved.
//
//  高德地图搜索管理类
//  
//

#import <Foundation/Foundation.h>
#import "DDSearchObj.h"

//关键字搜索数据回调block
typedef void(^keyWordSearchBlock)(NSArray <__kindof DDSearchPointAnnotation*> *pointAnnotaions);
//tip搜索数据回到block
typedef void(^tipsSearchBlock)(NSArray <__kindof DDSearchTip*> *tips);

@interface DDSearchManager : NSObject

+ (instancetype)sharedManager;

/* 2比1查询速度快；1的数据量比2大 。*/

/*
 1、关键字检索
 
 keyword为检索关键字；city可为空;block返回检索完后的数组，数组中是MAPointAnnotation的对象
 
 注意：关键字未设置城市信息（默认为全国搜索）时，如果涉及多个城市数据返回，仅会返回建议城市，请根据APP需求，选取城市进行搜索。
 */
- (void)keyWordsSearch:(NSString *)keyword city:(NSString *)city returnBlock:(keyWordSearchBlock)block;


/*
 2、输入提示查询
 
 block回调查询后的数组，该数组里是AMapTip对象
 */
- (void)inputTipsSearch:(NSString *)tips city:(NSString *)city returnBlock:(tipsSearchBlock)block;

@end
