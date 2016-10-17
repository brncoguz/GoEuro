//
//  GoEuroViewController.m
//  GoEuro
//
//  Created by Oguz Birinci on 11/10/2016.
//  Copyright © 2016 Oguz Birinci. All rights reserved.
//

#import "GoEuroViewController.h"
#import "GoEuroObject.h"
#import "Reachability.h"
#import "UIImageViewAligned.h"
#import <SystemConfiguration/SystemConfiguration.h>
#define JSON_URL_TRAIN @"https://api.myjson.com/bins/3zmcy"
#define JSON_URL_BUS @"https://api.myjson.com/bins/37yzm"
#define JSON_URL_FLIGHT @"https://api.myjson.com/bins/w60i"

@interface GoEuroViewController ()
@property (nonatomic,strong) NSMutableArray *objectHolderArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (nonatomic,strong) NSMutableArray *reports;
@property (nonatomic,strong) NSString *sortString;
@property (nonatomic, strong) NSArray *dataDictionaryTrain;
@property (nonatomic, strong) NSArray *dataDictionaryBus;
@property (nonatomic, strong) NSArray *dataDictionaryFlight;
@end

@implementation GoEuroViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.sortString = @"departure_time";
    if (self.connected)
        [self fetchTheData];
    else
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                           message:@"There is a problem in connection, you'll see the cache data!"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"OK"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                    }]];
        
        [self presentViewController:alertView animated:YES completion:NULL];
        
        [self fetchTheDataOffline];
    }
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

-(NSMutableArray *)objectHolderArray{
    if(!_objectHolderArray) _objectHolderArray = [[NSMutableArray alloc]init];
    return _objectHolderArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.objectHolderArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];
    
    GoEuroObject *currentTrip = [self.objectHolderArray objectAtIndex:indexPath.row];
    
    [((UIImageViewAligned *)[cell viewWithTag:1000]) sd_setImageWithURL:[NSURL URLWithString:currentTrip.logo]];
    [((UIImageViewAligned *)[cell viewWithTag:1000]) setAlignLeft:true];
    
    [((UILabel *)[cell viewWithTag:1001]) setText:[NSString stringWithFormat:@"€ %.2f", [currentTrip.price floatValue]]];
    [((UILabel *)[cell viewWithTag:1002]) setText:[NSString stringWithFormat:@"%@ - %@",currentTrip.depTime, currentTrip.arTime]];
    [((UILabel *)[cell viewWithTag:1003]) setText:[NSString stringWithFormat:@"%@ %@", [self howManyStops:currentTrip.numStop],[self time:currentTrip.depTime Difference:currentTrip.arTime]]];
    
    return cell;
}

- (NSString *)howManyStops:(NSNumber *)numStop
{
    NSString *numberOfStops = nil;
    if([numStop intValue] == 0)
        numberOfStops = @"Direct";
    else if([numStop intValue] == 1)
        numberOfStops = [NSString stringWithFormat:@"%@ stop", numStop];
    else
        numberOfStops = [NSString stringWithFormat:@"%@ stops", numStop];
    
    return numberOfStops;
}

- (NSString *)time:(NSString *)depTime Difference:(NSString *)arTime
{
    NSString *timeDifference = nil;
    
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];  // for 24 hour format
    
    NSDate *date1 = [df dateFromString:depTime];
    NSDate *date2 = [df dateFromString:arTime];
    float difference = [date2 timeIntervalSinceDate:date1];
    difference /= 60;
    timeDifference = [NSString stringWithFormat:@"%0.f:%0.fh", difference/60, fmodf(difference, 60)];
    
    return timeDifference;
}

- (IBAction)segmentSwitch
{
    self.objectHolderArray = nil;
    self.sortString = nil;
    [self loadTheData];
}

- (IBAction)buttonClicked:(id)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Sorting" message:@"How would you like to sort?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"By Departure Time" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        self.sortString = @"By Departure Time";
        self.objectHolderArray = nil;
        [self loadTheData];
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"By Arrival Time" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        self.sortString = @"By Arrival Time";
        self.objectHolderArray = nil;
        [self loadTheData];
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"By Price" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        self.sortString = @"By Price";
        self.objectHolderArray = nil;
        [self loadTheData];
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"By Number Of Stop" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        self.sortString = @"By Number Of Stop";
        self.objectHolderArray = nil;
        [self loadTheData];
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    // Present action sheet.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        actionSheet.popoverPresentationController.sourceView = self.view;
        actionSheet.popoverPresentationController.sourceRect = self.view.frame;
    }
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)fetchTheData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    dispatch_queue_t fetchTrain = dispatch_queue_create("goEuroTrain fetcher", NULL);
    dispatch_async(fetchTrain, ^{
        
        NSError *error = nil;
        NSURL *blogURLTrain = [NSURL URLWithString:JSON_URL_TRAIN];
        NSData *jsonDataTrain = [NSData dataWithContentsOfURL:blogURLTrain];
        self.dataDictionaryTrain = [NSJSONSerialization JSONObjectWithData:jsonDataTrain options:0 error:&error];
        [userDefaults setObject:self.dataDictionaryTrain forKey:@"1"];
        [userDefaults synchronize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    });
    
    dispatch_queue_t fetchBus = dispatch_queue_create("goEuroBus fetcher", NULL);
    dispatch_async(fetchBus, ^{
        
        NSError *error = nil;
        NSURL *blogURLBus = [NSURL URLWithString:JSON_URL_BUS];
        NSData *jsonDataBus = [NSData dataWithContentsOfURL:blogURLBus];
        self.dataDictionaryBus = [NSJSONSerialization JSONObjectWithData:jsonDataBus options:0 error:&error];
        [userDefaults setObject:self.dataDictionaryBus forKey:@"0"];
        [userDefaults synchronize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadTheData];
        });
    });
    
    dispatch_queue_t fetchFlight = dispatch_queue_create("goEuroFlight fetcher", NULL);
    dispatch_async(fetchFlight, ^{
        
        NSError *error = nil;
        NSURL *blogURLFlight = [NSURL URLWithString:JSON_URL_FLIGHT];
        NSData *jsonDataFlight = [NSData dataWithContentsOfURL:blogURLFlight];
        self.dataDictionaryFlight = [NSJSONSerialization JSONObjectWithData:jsonDataFlight options:0 error:&error];
        [userDefaults setObject:self.dataDictionaryFlight forKey:@"2"];
        [userDefaults synchronize];

        
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    });
    
//    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Warning"
//                                                                       message:@"There is a problem in connection, you'll see the cache data!"
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//    [alertView addAction:[UIAlertAction actionWithTitle:@"OK"
//                                                  style:UIAlertActionStyleDefault
//                                                handler:^(UIAlertAction * _Nonnull action) {
//                                                }]];
//    
//    [self presentViewController:alertView animated:YES completion:NULL];
    
}

- (void)fetchTheDataOffline
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.dataDictionaryBus = [userDefaults objectForKey:@"0"];
    self.dataDictionaryTrain = [userDefaults objectForKey:@"1"];
    self.dataDictionaryFlight = [userDefaults objectForKey:@"2"];
    
    [self loadTheData];
}

- (void)loadTheData
{
    NSSortDescriptor *lastDescriptor = nil;
    
    if ([self.sortString isEqualToString:@"By Departure Time"])
        lastDescriptor = [[NSSortDescriptor alloc] initWithKey:@"departure_time" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    else if ([self.sortString isEqualToString:@"By Arrival Time"])
        lastDescriptor = [[NSSortDescriptor alloc] initWithKey:@"arrival_time" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    else if ([self.sortString isEqualToString:@"By Price"])
        lastDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price_in_euros.doubleValue" ascending:YES];
    else if ([self.sortString isEqualToString:@"By Number Of Stop"])
        lastDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number_of_stops.longValue" ascending:YES];
    else
        lastDescriptor = [[NSSortDescriptor alloc] initWithKey:@"departure_time" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    
    if(self.segmentControl.selectedSegmentIndex == 0)
    {
        NSArray *descriptors = [NSArray arrayWithObjects:lastDescriptor, nil];
        NSArray *arr = [self.dataDictionaryBus sortedArrayUsingDescriptors:descriptors];
        for (int i = 0; i < arr.count; i++) {
            GoEuroObject *currentTrip = [[GoEuroObject alloc] initWithDictionary:[arr objectAtIndex:i]];
            [self.objectHolderArray addObject:currentTrip];
        }
    }
    else if(self.segmentControl.selectedSegmentIndex == 1)
    {
        NSArray *descriptors = [NSArray arrayWithObjects:lastDescriptor, nil];
        NSArray *arr = [self.dataDictionaryTrain sortedArrayUsingDescriptors:descriptors];
        for (int i = 0; i < arr.count; i++) {
            GoEuroObject *currentTrip = [[GoEuroObject alloc] initWithDictionary:[arr objectAtIndex:i]];
            [self.objectHolderArray addObject:currentTrip];
        }
    }
    else if(self.segmentControl.selectedSegmentIndex == 2)
    {
        NSArray *descriptors = [NSArray arrayWithObjects:lastDescriptor, nil];
        NSArray *arr = [self.dataDictionaryFlight sortedArrayUsingDescriptors:descriptors];
        for (int i = 0; i < arr.count; i++) {
            GoEuroObject *currentTrip = [[GoEuroObject alloc] initWithDictionary:[arr objectAtIndex:i]];
            [self.objectHolderArray addObject:currentTrip];
        }
    }
    [self.tableView reloadData];
}

@end
