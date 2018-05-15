//
//  BadgeOpenDetails.m
//  schoox
//
//  Created by Kostas Stamatis on 27/10/2017.
//  Copyright © 2017 Schoox. All rights reserved.
//

#import "BadgeOpenDetails.h"

@implementation BadgeOpenDetails

+(BadgeOpenDetails*)deserializeJsonDictionary:(NSDictionary *)jsonDict
{
    BadgeOpenDetails *badgeOpen = [[BadgeOpenDetails alloc] init];
    
    NSDictionary *jsonFieldsDict = @{@0:@"NumOfAwards", @1:@"alreadyAwarded", @2:@"awardable", @3:@"canAwarded", @4:@"deleted", @5:@"description", @6:@"hasEarnedThisBadge", @7:@"ownerType", @8:@"thumb", @9:@"title"};
    
    for (NSNumber *aKey in [jsonFieldsDict allKeys]) {
        
        NSString *jsonKey = [jsonFieldsDict objectForKey:aKey];
        
        switch ([aKey intValue]) {
            case 0:{
                if ([jsonDict objectForKey:jsonKey] != nil && [jsonDict objectForKey:jsonKey] != [NSNull null])
                {
                    badgeOpen.NumOfAwards = [jsonDict objectForKey:jsonKey];
                }
                else
                {
                    badgeOpen.NumOfAwards = [NSNumber numberWithInt:-1];
                }
            }break;
            case 1:{
                if ([jsonDict objectForKey:jsonKey] != nil && [jsonDict objectForKey:jsonKey] != [NSNull null])
                {
                    if ([[jsonDict objectForKey:jsonKey] isKindOfClass:[NSDictionary class]]) {
                        badgeOpen.alreadyAwarded = YES;
                    }else{
                        badgeOpen.alreadyAwarded = NO;
                    }
                    
                }
                else
                {
                    badgeOpen.alreadyAwarded = NO;
                }
            }break;
            case 2:{
                if ([jsonDict objectForKey:jsonKey] != nil && [jsonDict objectForKey:jsonKey] != [NSNull null])
                {
                    badgeOpen.awardable = [jsonDict objectForKey:jsonKey];
                }
                else
                {
                    badgeOpen.awardable = [NSNumber numberWithInt:-1];
                }
            }break;
            case 3:{
                if ([jsonDict objectForKey:jsonKey] != nil && [jsonDict objectForKey:jsonKey] != [NSNull null])
                {
                    badgeOpen.canAwarded = [[jsonDict objectForKey:jsonKey] boolValue];
                }
                else
                {
                    badgeOpen.canAwarded = NO;
                }
            }break;
            case 4:{
                if ([jsonDict objectForKey:jsonKey] != nil && [jsonDict objectForKey:jsonKey] != [NSNull null])
                {
                    badgeOpen.openDetailsDeleted = [[jsonDict objectForKey:jsonKey] boolValue];
                }
                else
                {
                    badgeOpen.openDetailsDeleted = NO;
                }
            }break;
            case 5:{
                if ([jsonDict objectForKey:jsonKey] != nil && [jsonDict objectForKey:jsonKey] != [NSNull null])
                {
                    badgeOpen.openDetailsDescription = [jsonDict objectForKey:jsonKey];
                }
                else
                {
                    badgeOpen.openDetailsDescription = @"";
                }
            }break;
            case 6:{
                if ([jsonDict objectForKey:jsonKey] != nil && [jsonDict objectForKey:jsonKey] != [NSNull null])
                {
                    if ([[jsonDict objectForKey:jsonKey] isKindOfClass:[NSDictionary class]]) {
                        badgeOpen.hasEarnedThisBadge = YES;
                    }else{
                        badgeOpen.hasEarnedThisBadge = NO;
                    }
                }
                else
                {
                    badgeOpen.hasEarnedThisBadge = NO;
                }
            }break;
            case 7:{
                if ([jsonDict objectForKey:jsonKey] != nil && [jsonDict objectForKey:jsonKey] != [NSNull null])
                {
                    badgeOpen.ownerType = [jsonDict objectForKey:jsonKey];
                }
                else
                {
                    badgeOpen.ownerType = @"";
                }
            }break;
            case 8:{
                if ([jsonDict objectForKey:jsonKey] != nil && [jsonDict objectForKey:jsonKey] != [NSNull null])
                {
                    badgeOpen.thumb = [jsonDict objectForKey:jsonKey];
                }
                else
                {
                    badgeOpen.thumb = @"";
                }
            }break;
            default:{
                if ([jsonDict objectForKey:jsonKey] != nil && [jsonDict objectForKey:jsonKey] != [NSNull null])
                {
                    badgeOpen.title = [jsonDict objectForKey:jsonKey];
                }
                else
                {
                    badgeOpen.title = @"";
                }
            }break;
        }
    }
    return badgeOpen;
}

@end
