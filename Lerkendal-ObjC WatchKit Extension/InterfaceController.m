//
//  InterfaceController.m
//  Lerkendal-ObjC WatchKit Extension
//
//  Created by Håkon Løvdal on 14/08/15.
//  Copyright © 2015 Håkon Løvdal. All rights reserved.
//

#import "InterfaceController.h"

@interface InterfaceController()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *availableWashers;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *availableDryers;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *availableLargeWashers;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    [self refreshWasherData];
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)refreshButton {
    NSLog(@"Requested refresh");
    [self setLoadingToOutlets];
    [self refreshWasherData];
}

- (void)setLoadingToOutlets {
    [[self availableWashers] setText:@"..."];
    [[self availableDryers] setText:@"..."];
    [[self availableLargeWashers] setText:@"..."];
}

- (void)refreshWasherData {
    // Should create service for this. Does exactly the same in InterfaceController
    NSURL *apiURL = [NSURL URLWithString:@"https://hakloev.no/sit/api/v1/available"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration ephemeralSessionConfiguration]];
    [[session dataTaskWithURL:apiURL completionHandler:^(NSData *data,
                                                         NSURLResponse *response,
                                                         NSError *error) {

        NSError *jsonError = nil;
        
        //NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSData *jsonData = [jsonString  dataUsingEncoding:NSUTF8StringEncoding];
    
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        
        if (!jsonDictionary) {
            NSLog(@"Error parsing JSON in InterfaceController");
            NSLog([NSString stringWithFormat:@"%@", [jsonError localizedDescription]]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self availableWashers] setText:@"N/A"];
                [[self availableDryers] setText:@"N/A"];
                [[self availableLargeWashers] setText:@"N/A"];
            });
        } else {
            NSLog(@"Success on getting JSON in InterfaceController");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self availableWashers] setText:[NSString stringWithFormat:@"%@", jsonDictionary[@"availableWashers"]]];
                [[self availableDryers] setText:[NSString stringWithFormat:@"%@", jsonDictionary[@"availableDryer"]]];
                [[self availableLargeWashers] setText:[NSString stringWithFormat:@"%@", jsonDictionary[@"availableLargeWasher"]]];
            });
        }
    }] resume];

    CLKComplicationServer *server = [CLKComplicationServer sharedInstance];
    for (CLKComplication *complication in [server activeComplications]) {
        [server reloadTimelineForComplication:complication];
    }
    
    
}

@end



