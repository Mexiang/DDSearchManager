//
//  ViewController.m
//  GDAddressSelected
//
//  Created by Dry on 2017/8/2.
//  Copyright © 2017年 Dry. All rights reserved.
//


#import "ViewController.h"
#import "DDSearchManager.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //用之前别忘了配置boundle id和高德AppKey
    
    
    [[DDSearchManager sharedManager] keyWordsSearch:@"清华" city:@"北京" returnBlock:^(NSArray<__kindof DDSearchPointAnnotation *> *pointAnnotaions) {
        
        
        for (DDSearchPointAnnotation *annotation in pointAnnotaions) {
            NSLog(@"%@ %@ (%f,%f)",annotation.title,annotation.subtitle,annotation.coordinate.latitude,annotation.coordinate.longitude);
        }

    }];
    
    
    
    //逆地理编码，请求附近兴趣点数据
    [[DDSearchManager sharedManager] poiReGeocode:CLLocationCoordinate2DMake(39.9087569028, 116.3973784447) returnBlock:^(NSArray<__kindof DDSearchPoi *> *pois) {
        
        for (DDSearchPoi *poi in pois) {
            NSLog(@"%@ %@",poi.name,poi.address);
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
