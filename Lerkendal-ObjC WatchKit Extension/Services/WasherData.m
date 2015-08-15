//
//  WasherData.m
//  Lerkendal-ObjC
//
//  Created by Håkon Løvdal on 15/08/15.
//  Copyright © 2015 Håkon Løvdal. All rights reserved.
//

#import "WasherData.h"

@implementation WasherData

// Defining callback block to use with getCurrentTimeLine in ComplicationController or InterfaceController
//typedef void (^DownloadCompletionBlock)(NSDictionary*);

+ (WasherData *)sharedInstance
{
    static id sharedInstance = nil;
    
    static dispatch_once_t lock;
    dispatch_once(&lock, ^{
        sharedInstance = [[super alloc] initInstance];
    });
    
    return sharedInstance;
}

- (id)initInstance
{
    self = [super init];
    
    if (self) {
        NSLog(@"Initiating singleton instance fo WasherData");
    }
    
    return self;
}

- (void)getCurrentMachineStatusesWithCallback:(void (^)(NSDictionary *))callback
{
    NSURL *apiURL = [NSURL URLWithString:@"https://hakloev.no/sit/api/v1/available"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    
    [[session dataTaskWithURL:apiURL completionHandler:^(NSData *data,
                                                         NSURLResponse *response,
                                                         NSError *error) {
        NSError *jsonError = nil;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        
        if (!jsonDictionary) {
            NSLog(@"Error parsing JSON in WasherData");
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(nil);
            });
        } else {
            NSLog(@"Success on getting JSON in WasherData");
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(jsonDictionary);
            });
        }
    }] resume];
}


@end
