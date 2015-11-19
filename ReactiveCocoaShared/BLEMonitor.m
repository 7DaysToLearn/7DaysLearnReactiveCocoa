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
    @weakify(self);
    RACSignal *dataSignal = [self dataSignal];
    dataSignal = [self binding:dataSignal];
    dataSignal = [self filter:dataSignal];
    dataSignal = [self timeout:dataSignal];
    
    [dataSignal
     subscribeNext:^(id x) {
         @strongify(self);
         [self didReceiveData:x];
     } error:^(NSError *error) {
         NSLog(@"超时!");
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
    data.length = arc4random()%20 + 13;
    int identifier = arc4random()%DEVICE_NUMBER;
    data.fromDeviceIdentifier = @(identifier);
    data.date = [NSDate date];
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

- (RACSignal *)binding:(RACSignal *)dataSignal {
    RACSubject *dataSubject = [RACSubject subject];
    RACMulticastConnection *connection = [dataSignal multicast:dataSubject];
    [connection connect];
    
    RACSignal *bindingSignal = [[[dataSubject bufferWithTime:BINDING_TIME onScheduler:[RACScheduler scheduler]]
                                 take:1]
                                flattenMap:^RACStream *(RACTuple *value) {
                                    NSArray *datas = [value allObjects];
                                    BLEData *maxData;
                                    for (BLEData *data in datas) {
                                        if (maxData == nil || maxData.RSSI < data.RSSI) {
                                            maxData = data;
                                        }
                                    }
                                    return [dataSubject filter:^BOOL(BLEData *value) {
                                        return [maxData.fromDeviceIdentifier isEqualToNumber:value.fromDeviceIdentifier];
                                    }];
                                }];
    return bindingSignal;
}

- (RACSignal *)filter:(RACSignal *)dataSignal {
    return [dataSignal filter:^BOOL(BLEData *value) {
        return value.length > 15;
    }];
}

- (RACSignal *)timeout:(RACSignal *)dataSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RACDisposable *dataDisposable = [dataSignal subscribe:subscriber];
        RACDisposable *timeoutDisposable = [[[RACSignal interval:TIMEOUT_INTERVAL onScheduler:[RACScheduler scheduler]]
                                             takeUntil:dataSignal].repeat
                                            subscribeNext:^(id x) {
                                                [subscriber sendError:[NSError errorWithDomain:RACSignalErrorDomain code:RACSignalErrorTimedOut userInfo:nil]];
                                            }];
        return [RACCompoundDisposable compoundDisposableWithDisposables:@[dataDisposable, timeoutDisposable]];
    }];
}
@end
