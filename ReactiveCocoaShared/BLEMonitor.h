//
//  BLEMonitor.h
//  ReactiveCocoaShared
//
//  Created by 陆晖 on 15/11/19.
//  Copyright © 2015年 陆晖. All rights reserved.
//

@import Foundation;

@interface BLEData : NSObject

/**
 *  值
 */
@property (nonatomic) int value;

/**
 *  信号强度
 */
@property (nonatomic) int RSSI;

/**
 *  数据长度
 */
@property (nonatomic) uint length;

/**
 *  数据来源的唯一标识
 */
@property (strong, nonatomic) NSNumber *fromDeviceIdentifier;

@end

typedef void(^BLEDidReceiveData)(BLEData *data);

@interface BLEMonitor : NSObject

@property (copy, nonatomic) BLEDidReceiveData didReceiveData;

- (void)start;
- (void)stop;

@end

