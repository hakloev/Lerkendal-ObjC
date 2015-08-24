//
//  BusTimeInterfaceController.m
//  Lerkendal-ObjC
//
//  Created by Håkon Løvdal on 23/08/15.
//  Copyright © 2015 Håkon Løvdal. All rights reserved.
//

#import "BusTimeInterfaceController.h"

#define BASE_URL @"http://bybussen.api.tmn.io/rt/"

@interface BusTimeInterfaceController ()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *loadingLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *busTableToCity;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *busTableFromCity;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *toCityLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *fromCityLabel;

@end

@implementation BusTimeInterfaceController

- (void)awakeWithContext:(id)context {
    NSLog(@"Awaked BusTimeInterfaceController with context%@", context);
    [super awakeWithContext:context];
    // Configure interface objects here.
    
    [self fetchBusDataWithURLs:context];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)fetchBusDataWithURLs:(NSDictionary *)urls
{
    [self setRefreshingLabelHiddenWithBOOL:NO];
     
    [self downloadBusDataFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@" ,BASE_URL, urls[@"toCity"]]] withCompletionHandler:^(NSArray *busDataToCity){
         if (busDataToCity != nil) {
             // Populate table
             [self populateBusTimeTable:self.busTableToCity withBusData:busDataToCity];
             [self.toCityLabel setHidden:NO];
         } else {
             [self.toCityLabel setHidden:YES];
             [self.busTableToCity setHidden:YES];
             NSLog(@"No busData, hidding busTableToCity");
         }
     }];
     
    [self downloadBusDataFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@" ,BASE_URL, urls[@"fromCity"]]] withCompletionHandler:^(NSArray *busDataFromCity) {
         if (busDataFromCity != nil) {
            [self populateBusTimeTable:self.busTableFromCity withBusData:busDataFromCity];
             [self.fromCityLabel setHidden:NO]; 
         } else {
             [self.fromCityLabel setHidden:YES];
             [self.busTableFromCity setHidden:YES];
             NSLog(@"No busData, hidding busTableFromCity");
         }
     }];
}

- (void)downloadBusDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSArray *))handler
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    
    [[session dataTaskWithURL:url completionHandler:^(NSData *data,
                                                      NSURLResponse *response,
                                                      NSError *error) {
        NSError *jsonError = nil;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        
        if (!jsonDictionary) {
            NSLog(@"Error parsing JSON in downloadBusData");
            handler(nil);
            
        } else {
            NSLog(@"Success on getting JSON in downloadBusData");
            handler([jsonDictionary objectForKey:@"next"]);
        }
        
    }] resume];
}

- (void)populateBusTimeTable:(WKInterfaceTable *)table withBusData:(NSArray *)busData
{
    [table setNumberOfRows:5 withRowType:@"busTimeRow"];
    
    for (NSInteger i = 0; i < table.numberOfRows; i++) {
        NSDictionary *busInformation = busData[i];
        BusTimeRowController *row = [table rowControllerAtIndex:i];
        
        [row.routeLabel setText:[busInformation objectForKey:@"l"]];
        
        NSString *busTime = [[[busInformation objectForKey:@"t"] componentsSeparatedByString:@" "] objectAtIndex:1];
        [row.timeLabel setText:busTime];
        
        ([busInformation objectForKey:@"rt"] == 0) ? [row.realtimeLabel setText:@""] : [row.realtimeLabel setText:@"S"];
        
        [row.destinationLabel setText:[busInformation objectForKey:@"d"]];
    }
    NSLog(@"Populated bus time table");
    [table setHidden:NO]; // Reactivates after setRefreshingLabel
    [[self loadingLabel] setHidden:YES]; // Activates after first download. Should activate after last.
}

- (void)setRefreshingLabelHiddenWithBOOL:(BOOL)status
{
    [[self loadingLabel] setHidden:status];
    [[self busTableToCity] setHidden:!status];
    [[self busTableFromCity] setHidden:!status];
    [[self toCityLabel] setHidden:!status];
    [[self fromCityLabel] setHidden:!status];
}

@end
