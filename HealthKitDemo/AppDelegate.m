//
//  AppDelegate.m
//  HealthKitDemo
//
//  Created by Andrew Dolce on 9/18/14.
//  Copyright (c) 2014 Intrepid Pursuits. All rights reserved.
//

#import "AppDelegate.h"
#import <HealthKit/HealthKit.h>

@interface AppDelegate ()

@property (strong, nonatomic) HKHealthStore *healthStore;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.healthStore = [[HKHealthStore alloc] init];
    [self setUpHealthStoreForTabBarControllers];
    return YES;
}

#pragma mark - HKHealthStore Setup

// Set the healthStore property on each view controller that will be presented to the user. The root view controller is a tab
// bar controller. Each tab of the root view controller is a view controller that presents HealthKit information to the user.
- (void)setUpHealthStoreForTabBarControllers {
    UITabBarController *tabBarController = (UITabBarController *)[self.window rootViewController];
    
    for (id viewController in tabBarController.viewControllers) {
        if ([viewController respondsToSelector:@selector(setHealthStore:)]) {
            [viewController setHealthStore:self.healthStore];
        }
    }
}


@end
