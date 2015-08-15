//
//  WasherRowController.h
//  Lerkendal-ObjC
//
//  Created by Håkon Løvdal on 15/08/15.
//  Copyright © 2015 Håkon Løvdal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@interface WasherRowController : NSObject

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *machineTypeLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *availableMachinesLabel;

@end
