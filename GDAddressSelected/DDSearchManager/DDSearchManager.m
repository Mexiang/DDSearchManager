//
//  DDSearchManager.m
//  MapNavTest
//
//  Created by Dry on 2017/1/14.
//  Copyright © 2017年 Dry. All rights reserved.
//

#import "DDSearchManager.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>

@interface DDSearchManager ()<AMapSearchDelegate>

@property (nonatomic, strong) AMapSearchAPI *searchAPI;

@property (nonatomic, copy) KeyWordSearchBlock keyWordSearchBlock;
@property (nonatomic, copy) TipsSearchBlock    tipSearchBlock;
@property (nonatomic, copy) DDPoisSearchBlock  ddPoisSearchBlock;

@end

@implementation DDSearchManager

+ (instancetype)sharedManager {
    static DDSearchManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[self alloc]init];
    });
    return manager;
}

/// 关键字查询
- (void)keyWordsSearch:(NSString *)keyword city:(NSString *)city returnBlock:(KeyWordSearchBlock)block
{
    if (keyword.length) {
        
        self.keyWordSearchBlock = block;
        
        AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc]init];
        
        request.keywords = keyword;
        if (city.length) {
            request.city = city;
            /* 搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
            request.cityLimit = YES;
        }
        /*返回扩展信息*/
        request.requireExtension = YES;
        request.requireSubPOIs = YES;
        
        /*发起关键字搜索*/
        [self.searchAPI AMapPOIKeywordsSearch:request];
    }
}

/// 输入提示查询
- (void)inputTipsSearch:(NSString *)tips city:(NSString *)city returnBlock:(TipsSearchBlock)block
{
    if (tips.length) {
        
        self.tipSearchBlock = block;
        
        AMapInputTipsSearchRequest *request = [[AMapInputTipsSearchRequest alloc]init];
        
        request.keywords = tips;
        if (city.length) {
            request.city = city;
            request.cityLimit = YES;
        }
        
        /*发起关键字搜索*/
        [self.searchAPI AMapInputTipsSearch:request];
    }
}

///逆地理编码查询POI点
- (void)poiReGeocode:(CLLocationCoordinate2D)coordinate returnBlock:(DDPoisSearchBlock)block
{
    if (coordinate.latitude > 0 && coordinate.longitude > 0)
    {
        self.ddPoisSearchBlock = block;
        
        //初始化逆地理编码请求类
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc]init];
        request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        request.requireExtension = YES; //返回扩展信息
        //发起逆地址编码查询
        [self.searchAPI AMapReGoecodeSearch:request];
    }
}

#pragma mark delegate
#pragma AMapSearchDelegate
//关键字查询代理回调
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0) {
        return;
    }
    
    NSMutableArray *poiAnnitations = [[NSMutableArray alloc]init];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        DDSearchPointAnnotation *annotation = [[DDSearchPointAnnotation alloc] init];
        [annotation setCoordinate:CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude)];
        [annotation setTitle:obj.name];
        [annotation setSubtitle:obj.address];
        
        [poiAnnitations addObject:annotation];
    }];

    if (self.keyWordSearchBlock) {
        self.keyWordSearchBlock (poiAnnitations);
    }
}
//输入提示查询代理回调
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    if (self.tipSearchBlock)
    {
        NSMutableArray *arr = [NSMutableArray array];
        for (int i=0; i<response.tips.count; i++)
        {
            AMapTip *tip = [response.tips objectAtIndex:i];
            if (tip.location.latitude!=0 && ![tip.uid isEqualToString:@""])
            {
                DDSearchTip *ddTip = [[DDSearchTip alloc] init];
                ddTip.name = tip.name;
                ddTip.adcode = tip.adcode;
                ddTip.district = tip.name;
                ddTip.address = tip.address;
                ddTip.coordinate = CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
                
                [arr addObject:tip];
            }
        }
        self.tipSearchBlock (arr);
    }
}
//逆地理编码查询附近POI回调
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response && response.regeocode)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        for (AMapPOI *mapPoi in response.regeocode.pois)
        {
            DDSearchPoi *poi = [[DDSearchPoi alloc] init];
            poi.name = mapPoi.name;
            poi.address = mapPoi.address;
            poi.coordinate = CLLocationCoordinate2DMake(mapPoi.location.latitude, mapPoi.location.longitude);
            poi.city = mapPoi.city;
            poi.cityCode = mapPoi.citycode;
            
            [arr addObject:poi];
        }
        
        self.ddPoisSearchBlock(arr);
    }
}

#pragma mark set/get
- (AMapSearchAPI *)searchAPI {
    if (!_searchAPI) {
        _searchAPI = [[AMapSearchAPI alloc]init];
        _searchAPI.delegate = self;
    }
    return _searchAPI;
}

@end
