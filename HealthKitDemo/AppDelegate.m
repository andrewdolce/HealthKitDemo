//
//  AppDelegate.m
//  HealthKitDemo
//
//  Created by Andrew Dolce on 9/18/14.
//  Copyright (c) 2014 Intrepid Pursuits. All rights reserved.
//

#import "AppDelegate.h"
#import <HealthKit/HealthKit.h>
#import "CaffeineDataStore.h"

@interface AppDelegate ()

@property (strong, nonatomic) HKHealthStore *healthStore;
@property (strong, nonatomic) CaffeineDataStore *caffeineDataStore;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.healthStore = [[HKHealthStore alloc] init];
    self.caffeineDataStore = [[CaffeineDataStore alloc] initWithHealthStore:self.healthStore];
    
    [self setUpCaffeineDataStoreForTabBarControllers];
    
    return YES;
}

#pragma mark - HKHealthStore Setup

// Set the caffeineDataStore property on each view controller that will be presented to the user. The root view controller is a tab
// bar controller. Each tab of the root view controller is a view controller that presents HealthKit information to the user.
- (void)setUpCaffeineDataStoreForTabBarControllers {
    UITabBarController *tabBarController = (UITabBarController *)[self.window rootViewController];
    for (id viewController in tabBarController.viewControllers) {
        if ([viewController respondsToSelector:@selector(setCaffeineDataStore:)]) {
            [viewController setCaffeineDataStore:self.caffeineDataStore];
        }
    }
}


@end
