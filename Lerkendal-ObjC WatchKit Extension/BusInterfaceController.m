//
//  BusInterfaceController.m
//  Lerkendal-ObjC
//
//  Created by Håkon Løvdal on 15/08/15.
//  Copyright © 2015 Håkon Løvdal. All rights reserved.
//

#import "BusInterfaceController.h"

@interface BusInterfaceController ()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *busTable;

@end

@implementation BusInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    [self loadBusData];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)refreshButton {
    [self loadBusData];
}


- (void)loadBusData
{
    [self fetchBusDataWithCompletionHandler:^(NSArray *busData){
        if (busData == nil) {
            NSLog(@"No bus data from fetchBusData");
            return;
        }
        [self.busTable setNumberOfRows:5 withRowType:@"busRow"];
        
        for (NSInteger i = 0; i < self.busTable.numberOfRows; i++) {
            NSDictionary *busInformation = busData[i];
            BusRowController *row = [self.busTable rowControllerAtIndex:i];
            
            [row.routeLabel setText:[busInformation objectForKey:@"l"]];
            
            NSString *busTime = [[[busInformation objectForKey:@"t"] componentsSeparatedByString:@" "] objectAtIndex:1];
            [row.timeLabel setText:busTime];
            
            ([busInformation objectForKey:@"rt"] == 0) ? [row.realtimeLabel setText:@""] : [row.realtimeLabel setText:@"S"];
            
            [row.destinationLabel setText:[busInformation objectForKey:@"d"]];
        }
        NSLog(@"Populated busTable");
    }];
}

- (void)fetchBusDataWithCompletionHandler:(void (^)(NSArray *))handler
{
    NSURL *apiURL = [NSURL URLWithString:@"http://bybussen.api.tmn.io/rt/16011264"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    
    [[session dataTaskWithURL:apiURL completionHandler:^(NSData *data,
                                                         NSURLResponse *response,
                                                         NSError *error) {
        NSError *jsonError = nil;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        
        if (!jsonDictionary) {
            NSLog(@"Error parsing JSON in fetchBusData");
            handler(nil);
            
        } else {
            NSLog(@"Success on getting JSON in fetchBusData");
            handler([jsonDictionary objectForKey:@"next"]);
        }
    }] resume];

    
}


@end



