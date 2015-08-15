//
//  InterfaceController.m
//  Lerkendal-ObjC WatchKit Extension
//
//  Created by Håkon Løvdal on 14/08/15.
//  Copyright © 2015 Håkon Løvdal. All rights reserved.
//

#import "InterfaceController.h"

@interface InterfaceController()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *washersTable;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    [self refreshWasherData];
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
    NSLog(@"Requested refresh");
    [self refreshWasherData];
}

- (void)refreshWasherData {
    WasherData *sharedInstance = [WasherData sharedInstance];
    [sharedInstance getCurrentMachineStatusesWithCallback:^(NSDictionary *washers) {
        if (washers != nil) {
            [self.washersTable setNumberOfRows:washers.count withRowType:@"washerRow"];
            
            NSInteger index = 0;
            for (NSString *key in washers) {
                WasherRowController *row = [[self washersTable] rowControllerAtIndex:index];
                NSString *machineType = nil;
                if ([key  isEqual: @"availableWashers"]) {
                    machineType = @"Vaskemaskiner";
                } else if ([key isEqual: @"availableLargeWasher"]) {
                    machineType = @"Stor vaskemaskin";
                } else {
                    machineType = @"Tørketrommel";
                }
                
                [row.machineTypeLabel setText:machineType];
                [row.availableMachinesLabel setText:[NSString stringWithFormat:@"%@", [washers objectForKey:key]]];
                index++;
            }
            NSLog(@"Populated washer table");
        }
        
        CLKComplicationServer *server = [CLKComplicationServer sharedInstance];
        for (CLKComplication *complication in [server activeComplications]) {
            [server reloadTimelineForComplication:complication];
        }
        
    }];
}

@end



