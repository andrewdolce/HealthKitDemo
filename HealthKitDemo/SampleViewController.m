//
//  FirstViewController.m
//  HealthKitDemo
//
//  Created by Andrew Dolce on 9/18/14.
//  Copyright (c) 2014 Intrepid Pursuits. All rights reserved.
//

#import "SampleViewController.h"
#import <HealthKit/HealthKit.h>

@interface SampleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *sampleTableView;
@property (strong, nonatomic) HKHealthStore *healthStore;
@property (strong, nonatomic) NSArray *samples;

@end

@implementation SampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.healthStore = [[HKHealthStore alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestHealthKitPermissionsWithCompletion:^(BOOL success, NSError *error) {
        [self refreshSamples];
    }];
}

#pragma mark - HealthKit Data Fetch

- (void)requestHealthKitPermissionsWithCompletion:(void(^)(BOOL success, NSError *error))completion {
    HKQuantityType *caffeineType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCaffeine];
    NSSet *types = [NSSet setWithObjects:caffeineType, nil];
    
    if ([HKHealthStore isHealthDataAvailable]) {
        [self.healthStore requestAuthorizationToShareTypes:types readTypes:types completion:^(BOOL success, NSError *error) {
            NSLog( @"Request success: %d error: %@", success, error);
            HKAuthorizationStatus status = [self.healthStore authorizationStatusForType:caffeineType];
            NSLog( @"Authorization status: %ld", status );
            if (completion) {
                completion(success, error);
            }
        }];
    }
}

- (void)refreshSamples {
    HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCaffeine];
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:type
                                                           predicate:nil
                                                               limit:100
                                                     sortDescriptors:nil
                                                      resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                                                          if (error) {
                                                              NSLog(@"Error fetching samples from HealthKit: %@", error);
                                                          } else {
                                                              self.samples = results;
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  [self.sampleTableView reloadData];
                                                              });
                                                          }
                                                      }];
    [self.healthStore executeQuery:query];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.samples count] > 0 ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.samples count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * const kSampleCellReuseIdentifier = @"kSampleCellReuseIdentifier";
    
    UITableViewCell *cell = [self.sampleTableView dequeueReusableCellWithIdentifier:kSampleCellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kSampleCellReuseIdentifier];
    }
    
    HKQuantitySample *sample = [self.samples objectAtIndex:indexPath.row];
    double milligrams = [sample.quantity doubleValueForUnit:[HKUnit unitFromString:@"mg"]];
    cell.textLabel.text = [NSString stringWithFormat:@"%g mg", milligrams];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Reported by %@ on %@", sample.source.name, sample.startDate];
    
    return cell;
}

#pragma mark - UITableViewDelegate


@end
