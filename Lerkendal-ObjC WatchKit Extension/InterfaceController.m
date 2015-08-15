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
    WasherData *sharedInstance = [WasherData sharedInstance];
    [sharedInstance getCurrentMachineStatusesWithCallback:^(NSDictionary *washers) {
        if (washers == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self availableWashers] setText:@"N/A"];
                [[self availableDryers] setText:@"N/A"];
                [[self availableLargeWashers] setText:@"N/A"];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self availableWashers] setText:[NSString stringWithFormat:@"%@", washers[@"availableWashers"]]];
                [[self availableDryers] setText:[NSString stringWithFormat:@"%@", washers[@"availableDryer"]]];
                [[self availableLargeWashers] setText:[NSString stringWithFormat:@"%@", washers[@"availableLargeWasher"]]];
            });
            
            CLKComplicationServer *server = [CLKComplicationServer sharedInstance];
            for (CLKComplication *complication in [server activeComplications]) {
                [server reloadTimelineForComplication:complication];
            }
        }
    }];
}

@end



