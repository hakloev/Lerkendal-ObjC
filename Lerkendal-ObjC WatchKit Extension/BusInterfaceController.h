//
//  BusInterfaceController.h
//  Lerkendal-ObjC
//
//  Created by Håkon Løvdal on 15/08/15.
//  Copyright © 2015 Håkon Løvdal. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

#import "BusRowController.h"

@interface BusInterfaceController : WKInterfaceController

- (void)fetchBusData;
- (void)downloadBusDataFromURL: (NSURL*)url withCompletionHandler: (void (^)(NSArray*))handler;
- (void)populateTable: (WKInterfaceTable*)table withBusData: (NSArray*)busData;
- (void)setRefreshingLabelWithBOOL:(BOOL)status;

@end
