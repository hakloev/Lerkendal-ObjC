//
//  BusInterfaceController.m
//  Lerkendal-ObjC
//
//  Created by Håkon Løvdal on 15/08/15.
//  Copyright © 2015 Håkon Løvdal. All rights reserved.
//

#import "BusInterfaceController.h"

static NSDictionary* busStops = nil;

@interface BusInterfaceController ()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *loadingLabel;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *busStopTable;

@end

@implementation BusInterfaceController

- (void)awakeWithContext:(id)context {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        busStops = @{
          @"Lerkendal Stadion" : [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"16011264", @"toCity",
                                  @"16010264", @"fromCity", nil],
          @"Tempe Kirke" : [NSDictionary dictionaryWithObjectsAndKeys:
                            @"16010649", @"toCity",
                            @"", @"fromCity", nil],
          };
    });
    
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    [self populateBusStopTable];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

-(void)populateBusStopTable
{
    [self.busStopTable setNumberOfRows:[busStops count] withRowType:@"busStopRow"];
    
    NSArray *keyArray = [busStops allKeys];
    
    // Should use keyArray as index
    for (NSInteger i = 0; i < [self.busStopTable numberOfRows]; i++) {
        BusStopRowController *row = [self.busStopTable rowControllerAtIndex:i];
        [row.busStopName setText:[keyArray objectAtIndex:i]];
    }
    NSLog(@"Populated busStopTable");
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
    NSLog(@"Presenting BusTimeInterfaceController");
    
    NSArray *valueArray = [busStops allValues];
    [self presentControllerWithName:@"BusTimeInterfaceController" context:[valueArray objectAtIndex:rowIndex]];
}

@end



