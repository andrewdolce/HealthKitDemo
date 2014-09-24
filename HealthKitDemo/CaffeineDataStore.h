//
//  CaffeineDataStore.h
//  HealthKitDemo
//
//  Created by Andrew Dolce on 9/23/14.
//  Copyright (c) 2014 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

extern NSString * const kCaffeineDataUpdateNotificiation;

@interface CaffeineDataStore : NSObject

- (instancetype)initWithHealthStore:(HKHealthStore *)healthStore;

- (void)fetchCaffieneSamplesWithCompletion:(void(^)(NSArray *samples, NSError *error))completion;
- (void)saveCaffeineSample:(double)caffeineInMilligrams completion:(void(^)(BOOL success, NSError *error))completion;

- (void)startObservingUpdates;

@end
