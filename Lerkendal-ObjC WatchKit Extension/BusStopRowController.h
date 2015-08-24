//
//  BusStopRowController.h
//  Lerkendal-ObjC
//
//  Created by Håkon Løvdal on 23/08/15.
//  Copyright © 2015 Håkon Løvdal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WatchKit/WatchKit.h>

@interface BusStopRowController : NSObject

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *busStopName;

@end
