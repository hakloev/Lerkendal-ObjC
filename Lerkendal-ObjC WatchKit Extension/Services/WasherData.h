//
//  WasherData.h
//  Lerkendal-ObjC
//
//  Created by Håkon Løvdal on 15/08/15.
//  Copyright © 2015 Håkon Løvdal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WasherData : NSObject

+ (WasherData *) sharedInstance;

// Defining callback block to use with getCurrentTimeLine
// Returns nothing, but accepts a NSDictionary as argument
- (void)getCurrentMachineStatusesWithCallback:(void (^)(NSDictionary *))callback;

@end
