//
//  BLEMonitor.m
//  ReactiveCocoaShared
//
//  Created by 陆晖 on 15/11/19.
//  Copyright © 2015年 陆晖. All rights reserved.
//

#import "BLEMonitor.h"

@implementation BLEData

@end

@implementation BLEMonitor

- (void)start {
    //TODO:每0.5秒自动生成一个随机数据
    [self didReceiveData:[self generateData]];
}

- (void)stop {
    //STUB
}

- (void)didReceiveData:(BLEData *)data {
    if (self.didReceiveData) {
        self.didReceiveData(data);
    }
}

- (BLEData *)generateData {
    BLEData *data = [BLEData new];
    data.value = arc4random()%7+32;
    data.RSSI = arc4random()%100;
    data.length = arc4random()%20;
    int identifier = arc4random()%5;
    data.fromDeviceIdentifier = @(identifier);
    return data;
}

@end
