//
//  SecondViewController.m
//  HealthKitDemo
//
//  Created by Andrew Dolce on 9/18/14.
//  Copyright (c) 2014 Intrepid Pursuits. All rights reserved.
//

#import "NewEntryViewController.h"
#import <HealthKit/HealthKit.h>

@interface NewEntryViewController () <UITextFieldDelegate>

// TODO: Set this with DI
@property (strong, nonatomic) HKHealthStore *healthStore;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;

@end

@implementation NewEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.healthStore = [[HKHealthStore alloc] init];
}

- (void)saveQuantityIfAble {
    double value = [self.quantityTextField.text doubleValue];
    if (value > 0) {
        HKUnit *unit = [HKUnit unitFromString:@"mg"];
        HKQuantity *quantity = [HKQuantity quantityWithUnit:unit doubleValue:value];
        HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCaffeine];
        NSDate *now = [NSDate date];
        HKQuantitySample *sample = [HKQuantitySample quantitySampleWithType:type quantity:quantity startDate:now endDate:now];
        [self.healthStore saveObject:sample withCompletion:^(BOOL success, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.quantityTextField.enabled = YES;
                if (success) {
                    NSLog( @"Successfully saved quantity to HealthKit!" );
                    [self.quantityTextField setText:@""];
                } else {
                    NSLog( @"Error saving to HK: %@", error );
                }
            });
        }];
    }
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self saveQuantityIfAble];
    self.quantityTextField.enabled = NO;
    return NO;
}

@end
