//
//  ComplicationController.m
//  Lerkendal-ObjC WatchKit Extension
//
//  Created by Håkon Løvdal on 14/08/15.
//  Copyright © 2015 Håkon Løvdal. All rights reserved.
//

#import "ComplicationController.h"

@interface ComplicationController ()

@property NSString *availableWashers;

@end

@implementation ComplicationController

#pragma mark - Timeline Configuration

- (void)getSupportedTimeTravelDirectionsForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimeTravelDirections directions))handler {
    handler(CLKComplicationTimeTravelDirectionNone);
}

- (void)getTimelineStartDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler(nil);
}

- (void)getTimelineEndDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler(nil);
}

- (void)getPrivacyBehaviorForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationPrivacyBehavior privacyBehavior))handler {
    handler(CLKComplicationPrivacyBehaviorShowOnLockScreen);
}

#pragma mark - Timeline Population

- (void)getCurrentTimelineEntryForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimelineEntry * __nullable))handler {
    // Call the handler with the current timeline entry
    
    WasherData *sharedInstance = [WasherData sharedInstance];
    [sharedInstance getCurrentMachineStatusesWithCallback:^(NSDictionary *washers){
        CLKComplicationTemplate *template = nil;
        switch (complication.family) {
            case CLKComplicationFamilyModularSmall: {
                CLKComplicationTemplateModularSmallStackText *complication = [[CLKComplicationTemplateModularSmallStackText alloc] init];
                complication.line2TextProvider = [CLKSimpleTextProvider textProviderWithText:@"VM"];
                if (washers == nil) {
                    complication.line1TextProvider = [CLKSimpleTextProvider textProviderWithText:@"N/A"];
                } else {
                    NSLog(@"ModularSmall called");
                    complication.line1TextProvider = [CLKSimpleTextProvider textProviderWithText:[NSString stringWithFormat:@"%@", washers[@"availableWashers"]]];
                }
                template = complication;
                break;
            }
            case CLKComplicationFamilyModularLarge: {
                break;
            }
            case CLKComplicationFamilyUtilitarianSmall: {
                break;
            }
            case CLKComplicationFamilyUtilitarianLarge: {
                CLKComplicationTemplateUtilitarianLargeFlat *complication = [[CLKComplicationTemplateUtilitarianLargeFlat alloc] init];
                if (washers == nil) {
                    complication.textProvider = [CLKSimpleTextProvider textProviderWithText:@"STATUS N/A"];
                } else {
                    NSLog(@"UtiliarianLarge called");
                    NSString *stringToDisplay = [NSString stringWithFormat:@"VM: %@ SM: %@ T: %@", [washers objectForKey:@"availableWashers"],  [washers objectForKey:@"availableLargeWasher"],  [washers objectForKey:@"availableDryer"]];
                    complication.textProvider = [CLKSimpleTextProvider textProviderWithText:stringToDisplay];
                }
                template = complication;
                break;
            }
            case CLKComplicationFamilyCircularSmall: {
                break;
            }
        }
        
        if (template) {
            CLKComplicationTimelineEntry *timelineEntry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date]  complicationTemplate:template];
            handler(timelineEntry);
        } else {
            handler(nil);
        }
    }];
   
    
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication beforeDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries prior to the given date
    handler(nil);
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication afterDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries after to the given date
    handler(nil);
}

#pragma mark Update Scheduling

- (void)getNextRequestedUpdateDateWithHandler:(void(^)(NSDate * __nullable updateDate))handler {
    // Call the handler with the date when you would next like to be given the opportunity to update your complication content
    handler([NSDate dateWithTimeIntervalSinceNow:60*30]); // Update every half hour
}

#pragma mark - Placeholder Templates

- (void)getPlaceholderTemplateForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTemplate * __nullable complicationTemplate))handler {
    // This method will be called once per supported complication, and the results will be cached
    
    CLKComplicationTemplate *template = nil;
    
    switch (complication.family) {
        case CLKComplicationFamilyModularSmall: {
            CLKComplicationTemplateModularSmallStackText *modularTemplate = [[CLKComplicationTemplateModularSmallStackText alloc] init];
            modularTemplate.line2TextProvider = [CLKSimpleTextProvider textProviderWithText:@"VM"];
            modularTemplate.line1TextProvider = [CLKSimpleTextProvider textProviderWithText:@"--"];
            template = modularTemplate;
            break;
        }
        case CLKComplicationFamilyModularLarge: {
            template = nil;
            break;
        }
        case CLKComplicationFamilyUtilitarianSmall: {
            template = nil;
            break;
        }
        case CLKComplicationFamilyUtilitarianLarge: {
            CLKComplicationTemplateUtilitarianLargeFlat *modularTemplate = [[CLKComplicationTemplateUtilitarianLargeFlat alloc] init];
            modularTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:@"STATUS: N/A" shortText:@"VM: N/A"];
            template = modularTemplate;
        }
        case CLKComplicationFamilyCircularSmall: {
            template = nil;
            break;
        }
        default:
            break;
    }
    
    handler(template);
}

@end
