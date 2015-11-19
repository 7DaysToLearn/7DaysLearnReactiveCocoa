//
//  BLEMonitor.m
//  ReactiveCocoaShared
//
//  Created by 陆晖 on 15/11/19.
//  Copyright © 2015年 陆晖. All rights reserved.
//

#import "BLEMonitor.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#define DATA_GENERATE_TIME_INTERVAL 0.5
#define BINDING_TIME 3
#define DEVICE_NUMBER 2
#define TIMEOUT_INTERVAL (BINDING_TIME+10)

@implementation BLEData

- (NSString *)description {
    return [NSString stringWithFormat:@"%@\n%@\n%@-%@", self.date, self.fromDeviceIdentifier, @(self.length), @(self.value)];
}

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
    data.length = arc4random()%20 + 13;
    int identifier = arc4random()%DEVICE_NUMBER;
    data.fromDeviceIdentifier = @(identifier);
    data.date = [NSDate date];
    return data;
}
@end
