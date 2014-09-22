//
//  FirstViewController.h
//  HealthKitDemo
//
//  Created by Andrew Dolce on 9/18/14.
//  Copyright (c) 2014 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HealthKit/HealthKit.h>

@interface SampleViewController : UIViewController

@property (strong, nonatomic) HKHealthStore *healthStore;

@end

