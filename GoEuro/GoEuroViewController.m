//
//  GoEuroViewController.m
//  GoEuro
//
//  Created by Oguz Birinci on 11/10/2016.
//  Copyright © 2016 Oguz Birinci. All rights reserved.
//

#import "GoEuroViewController.h"
#import "GoEuroCell.h"
#import "GoEuroObject.h"
#import "Reachability.h"
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
@end

@implementation GoEuroViewController

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section
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
    static NSString *CellIdentifier = @"Cell";
    GoEuroCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    GoEuroObject *currentTrip = [self.objectHolderArray objectAtIndex:indexPath.row];
    cell.lblTime.text = [NSString stringWithFormat:@"%@ - %@",currentTrip.depTime, currentTrip.arTime];
    cell.lblPrice.text = [NSString stringWithFormat:@"€ %0.2f", currentTrip.price];
    cell.lblDuration.text = [NSString stringWithFormat:@"%@ %@", [self howManyStops:currentTrip.numStop],[self time:currentTrip.depTime Difference:currentTrip.arTime]];
    cell.imgLogo.image = [self imageFromUrl:currentTrip.logo];

    return cell;
}

- (NSString *)howManyStops:(int)numStop
{
    NSString *numberOfStops = nil;
    if(numStop == 0)
        numberOfStops = @"Direct";
    else if(numStop == 1)
        numberOfStops = [NSString stringWithFormat:@"%d stop", numStop];
    else
        numberOfStops = [NSString stringWithFormat:@"%d stops", numStop];
    
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

- (UIImage *)imageFromUrl:(NSString *)urlString
{
    NSArray *companyLogo = [urlString componentsSeparatedByString:@"/"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *imageData = [defaults dataForKey:[NSString stringWithFormat:@"%@", [companyLogo lastObject]]];
    if (imageData)
    {
        UIImage *contactImage = [UIImage imageWithData:imageData];
        return contactImage;
    }
    
    UIImage *image = nil;
    urlString = [urlString stringByReplacingOccurrencesOfString:@"{size}"
                                         withString:@"63"];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", urlString]];
    image = [UIImage imageWithCIImage:[CIImage imageWithContentsOfURL:url]];
    
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    imageData = UIImagePNGRepresentation(newImage);
    [defaults setObject:imageData forKey:[NSString stringWithFormat:@"%@", [companyLogo lastObject]]];
    
    [defaults synchronize];
    
    return image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchTheData];
    [self loadTheData];
}

- (IBAction)segmentSwitch
{
    self.objectHolderArray = nil;
    self.sortString = nil;
    [self loadTheData];
}

- (IBAction)buttonClicked:(id)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Action Sheet" message:@"Using the alert controller" preferredStyle:UIAlertControllerStyleActionSheet];
    
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
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"By Arrivel Time" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        self.sortString = @"By Arrivel Time";
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
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)fetchTheData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    dispatch_queue_t fetchQ = dispatch_queue_create("goEuro fetcher", NULL);
    dispatch_async(fetchQ, ^{
        
        NSURL *blogURLBus = [NSURL URLWithString:JSON_URL_BUS];
        NSURL *blogURLTrain = [NSURL URLWithString:JSON_URL_TRAIN];
        NSURL *blogURLFlight = [NSURL URLWithString:JSON_URL_FLIGHT];
        
        NSData *jsonDataBus = [NSData dataWithContentsOfURL:blogURLBus];
        NSData *jsonDataTrain = [NSData dataWithContentsOfURL:blogURLTrain];
        NSData *jsonDataFlight = [NSData dataWithContentsOfURL:blogURLFlight];
        
        NSError *error = nil;
        NSArray *dataDictionaryBus = [NSJSONSerialization JSONObjectWithData:jsonDataBus options:0 error:&error];
        NSArray *dataDictionaryTrain = [NSJSONSerialization JSONObjectWithData:jsonDataTrain options:0 error:&error];
        NSArray *dataDictionaryFlight = [NSJSONSerialization JSONObjectWithData:jsonDataFlight options:0 error:&error];
        
        
        [userDefaults setObject:dataDictionaryBus forKey:@"0"];
        [userDefaults setObject:dataDictionaryTrain forKey:@"1"];
        [userDefaults setObject:dataDictionaryFlight forKey:@"2"];
        
        
        
        [userDefaults synchronize];
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    });
    
}

- (void)loadTheData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [userDefaults objectForKey:[NSString stringWithFormat:@"%ld", (long)self.segmentControl.selectedSegmentIndex]];
    
    for (NSDictionary *bpDictionary in arr)
    {
        GoEuroObject *currentTrip = [[GoEuroObject alloc]initWithId:[[bpDictionary objectForKey:@"id"]doubleValue]
                                                               logo:[bpDictionary objectForKey:@"provider_logo"]
                                                              price:[[bpDictionary objectForKey:@"price_in_euros"]doubleValue]
                                                            depTime:[bpDictionary objectForKey:@"departure_time"]
                                                             arTime:[bpDictionary objectForKey:@"arrival_time"]
                                                            numStop:[[bpDictionary objectForKey:@"number_of_stops"]doubleValue]];
        [self.objectHolderArray addObject:currentTrip];
    }
    [self.tableView reloadData];
}

@end