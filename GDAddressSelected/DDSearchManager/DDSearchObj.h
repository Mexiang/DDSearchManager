//
//  DDSearchObj.h
//  GDAddressSelected
//
//  Created by Dry on 2017/8/4.
//  Copyright © 2017年 Dry. All rights reserved.
//
//  该文件定义了搜索结果的基础数据类型。
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DDSearchObj : NSObject



@end


///输入提示
@interface DDSearchTip : DDSearchObj

///名称
@property (nonatomic, copy) NSString   *name;
///区域编码
@property (nonatomic, copy) NSString   *adcode;
///所属区域
@property (nonatomic, copy) NSString   *district;
///地址
@property (nonatomic, copy) NSString   *address;
///经纬度
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end


///点标注数据
@interface DDSearchPointAnnotation : DDSearchObj

///经纬度
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
///标题
@property (nonatomic, copy) NSString *title;
///副标题
@property (nonatomic, copy) NSString *subtitle;

@end

