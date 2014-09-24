//
//  FirstViewController.m
//  HealthKitDemo
//
//  Created by Andrew Dolce on 9/18/14.
//  Copyright (c) 2014 Intrepid Pursuits. All rights reserved.
//

#import "SampleViewController.h"

@interface SampleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *sampleTableView;
@property (strong, nonatomic) NSArray *samples;

@end

@implementation SampleViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshSamples];
}

#pragma mark - HealthKit Data Fetch

- (void)refreshSamples {
    [self.caffeineDataStore fetchCaffieneSamplesWithCompletion:^(NSArray *samples, NSError *error) {
        if (samples) {
            self.samples = samples;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.sampleTableView reloadData];
            });
        }
    }];
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

#pragma mark - NSNotifications

- (void)setCaffeineDataStore:(CaffeineDataStore *)caffeineDataStore {
    if (_caffeineDataStore) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:kCaffeineDataUpdateNotificiation
                                                      object:_caffeineDataStore];
    }
    _caffeineDataStore = caffeineDataStore;
    if (_caffeineDataStore) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didObserveDataUpdateNotification:)
                                                     name:kCaffeineDataUpdateNotificiation
                                                   object:self.caffeineDataStore];
    }
}

- (void)didObserveDataUpdateNotification:(NSNotification *)notification {
    [self refreshSamples];
}

@end
