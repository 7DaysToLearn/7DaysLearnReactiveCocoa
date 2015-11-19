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

@implementation BLEData

@end

@implementation BLEMonitor

- (void)start {
    @weakify(self);
    [[self dataSignal]
     subscribeNext:^(id x) {
         @strongify(self);
         [self didReceiveData:x];
     }];
}

- (void)stop {
    //Do nothing
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

- (RACSignal *)dataSignal {
    @weakify(self);
    return [[[[[RACSignal interval:DATA_GENERATE_TIME_INTERVAL onScheduler:[RACScheduler scheduler]]
              takeUntil:[self rac_signalForSelector:@selector(stop)]]
             takeUntil:[self rac_signalForSelector:_cmd]]
            merge:[RACSignal return:[NSDate date]]]
            map:^id(id value) {
                @strongify(self);
                return [self generateData];
            }];
}
@end
