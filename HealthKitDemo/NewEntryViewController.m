//
//  SecondViewController.m
//  HealthKitDemo
//
//  Created by Andrew Dolce on 9/18/14.
//  Copyright (c) 2014 Intrepid Pursuits. All rights reserved.
//

#import "NewEntryViewController.h"

@interface NewEntryViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;

@end

@implementation NewEntryViewController

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
                [self.quantityTextField setText:@""];
                if (success) {
                    NSLog( @"Successfully saved quantity to HealthKit!" );
                    [self showAlertWithTitle:@"Success" message:@"Your data was saved!"];
                } else {
                    NSLog( @"Error saving to HK: %@", error );
                    [self showAlertWithTitle:@"Error" message:@"Your data could not be saved."];
                }
            });
        }];
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self saveQuantityIfAble];
    self.quantityTextField.enabled = NO;
    return NO;
}

@end
