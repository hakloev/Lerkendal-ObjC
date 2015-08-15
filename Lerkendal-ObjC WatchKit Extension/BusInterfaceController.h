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

- (void)loadBusData;
- (void)fetchBusDataWithCompletionHandler:(void (^)(NSArray *))handler;

@end