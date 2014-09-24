//
//  CaffeineDataStore.m
//  HealthKitDemo
//
//  Created by Andrew Dolce on 9/23/14.
//  Copyright (c) 2014 Intrepid Pursuits. All rights reserved.
//

#import "CaffeineDataStore.h"

NSString * const kCaffeineDataUpdateNotificiation = @"kCaffeineDataUpdateNotificiation";

@interface CaffeineDataStore ()

@property (strong, nonatomic) HKHealthStore *healthStore;

@end

@implementation CaffeineDataStore

- (instancetype)initWithHealthStore:(HKHealthStore *)healthStore {
    self = [super init];
    if (self) {
        self.healthStore = healthStore;
        [self startObservingUpdates];
    }
    return self;
}

- (void)fetchCaffieneSamplesWithCompletion:(void (^)(NSArray *samples, NSError *error))completion {
    [self requestAuthorizationWithCompletion:^(BOOL success, NSError *error) {
        HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCaffeine];
        HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:type
                                                               predicate:nil
                                                                   limit:100
                                                         sortDescriptors:nil
                                                          resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                                                              if (error) {
                                                                  NSLog(@"Error fetching samples from HealthKit: %@", error);
                                                              }
                                                              if (completion) {
                                                                  completion(results, error);
                                                              }
                                                          }];
        [self.healthStore executeQuery:query];
    }];
}

- (void)saveCaffeineSample:(double)caffeineInMilligrams completion:(void (^)(BOOL success, NSError *error))completion {
    [self requestAuthorizationWithCompletion:^(BOOL success, NSError *error) {
        HKUnit *unit = [HKUnit unitFromString:@"mg"];
        HKQuantity *quantity = [HKQuantity quantityWithUnit:unit doubleValue:caffeineInMilligrams];
        HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCaffeine];
        NSDate *now = [NSDate date];
        HKQuantitySample *sample = [HKQuantitySample quantitySampleWithType:type quantity:quantity startDate:now endDate:now];
        [self.healthStore saveObject:sample withCompletion:completion];
    }];
}

- (void)startObservingUpdates {
    HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCaffeine];
    HKObserverQuery *observationQuery = [[HKObserverQuery alloc] initWithSampleType:type predicate:nil updateHandler:^(HKObserverQuery *query, HKObserverQueryCompletionHandler completionHandler, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCaffeineDataUpdateNotificiation object:self];
    }];
    [self.healthStore executeQuery:observationQuery];
}

#pragma mark - Authorization Request Helper

- (void)requestAuthorizationWithCompletion:(void(^)(BOOL success, NSError *error))completion {
    if ([HKHealthStore isHealthDataAvailable]) {
        HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCaffeine];
        NSSet *types = [NSSet setWithObjects:type, nil];
        [self.healthStore requestAuthorizationToShareTypes:types readTypes:types completion:^(BOOL success, NSError *error) {
            if (error) {
                NSLog(@"Error requesting HealthKit permissions: %@", error);
            }
            if (completion) {
                completion(success, error);
            }
        }];
    } else if (completion) {
        completion(NO, nil);
    }
}

@end
