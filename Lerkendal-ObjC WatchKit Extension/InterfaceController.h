//
//  InterfaceController.h
//  Lerkendal-ObjC WatchKit Extension
//
//  Created by Håkon Løvdal on 14/08/15.
//  Copyright © 2015 Håkon Løvdal. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

#import <ClockKit/ClockKit.h>

#import "Services/WasherData.h"
#import "WasherRowController.h"

@interface InterfaceController : WKInterfaceController

- (void)refreshWasherData;
- (void)refreshComplications;

@end
