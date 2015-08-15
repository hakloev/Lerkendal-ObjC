//
//  BusInterfaceController.m
//  Lerkendal-ObjC
//
//  Created by Håkon Løvdal on 15/08/15.
//  Copyright © 2015 Håkon Løvdal. All rights reserved.
//

#import "BusInterfaceController.h"

@interface BusInterfaceController ()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *loadingLabel;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *busTableToCity;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *busTableFromCity;

@end

@implementation BusInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    [self fetchBusData];
}

- (void)willActivate {
    [self fetchBusData];
    
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)refreshButton {
    [self fetchBusData];
}

- (void)setRefreshingLabelWithBOOL:(BOOL)status
{
    [[self loadingLabel] setHidden:status];
    [[self busTableToCity] setHidden:!status];
    [[self busTableFromCity] setHidden:!status];
}


- (void)fetchBusData
{
    NSURL *apiURLToCity = [NSURL URLWithString:@"http://bybussen.api.tmn.io/rt/16011264"];
    NSURL *apiURLFromCity = [NSURL URLWithString:@"http://bybussen.api.tmn.io/rt/16010264"];
    
    [self setRefreshingLabelWithBOOL:NO];
    
    [self downloadBusDataFromURL:apiURLToCity withCompletionHandler:^(NSArray *busDataToCity){
        if (busDataToCity != nil) {
            // Populate table
            [self populateTable:self.busTableToCity withBusData:busDataToCity];
        }
    }];
    
    [self downloadBusDataFromURL:apiURLFromCity withCompletionHandler:^(NSArray *busDataFromCity) {
        if (busDataFromCity != nil) {
            [self populateTable:self.busTableFromCity withBusData:busDataFromCity];
        }
        // Else: Clean table or something like that
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

- (void)populateTable:(WKInterfaceTable *)table withBusData:(NSArray *)busData
{
    [table setNumberOfRows:5 withRowType:@"busRow"];
    
    for (NSInteger i = 0; i < table.numberOfRows; i++) {
        NSDictionary *busInformation = busData[i];
        BusRowController *row = [table rowControllerAtIndex:i];
        
        [row.routeLabel setText:[busInformation objectForKey:@"l"]];
        
        NSString *busTime = [[[busInformation objectForKey:@"t"] componentsSeparatedByString:@" "] objectAtIndex:1];
        [row.timeLabel setText:busTime];
        
        ([busInformation objectForKey:@"rt"] == 0) ? [row.realtimeLabel setText:@""] : [row.realtimeLabel setText:@"S"];
        
        [row.destinationLabel setText:[busInformation objectForKey:@"d"]];
    }
    NSLog(@"Populated bus table");
    [table setHidden:NO]; // Reactivates after setRefreshingLabel
    [[self loadingLabel] setHidden:YES]; // Activates after first download. Should activate after last.
}


@end



