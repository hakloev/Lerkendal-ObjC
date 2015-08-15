//
//  BusRowController.h
//  Lerkendal-ObjC
//
//  Created by Håkon Løvdal on 15/08/15.
//  Copyright © 2015 Håkon Løvdal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WatchKit/WatchKit.h>

@interface BusRowController : NSObject

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *routeLabel;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *timeLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *realtimeLabel;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *destinationLabel;

@end
