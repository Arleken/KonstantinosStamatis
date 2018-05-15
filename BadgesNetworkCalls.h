//
//  BadgesNetworkCalls.h
//  schoox
//
//  Created by Kostas Stamatis on 09/10/2017.
//  Copyright © 2017 Schoox. All rights reserved.
//

#import "BaseNetwork.h"
#import "ErrorObject.h"
#import "Badges.h"
#import "BadgeOpenDetails.h"

@protocol BadgesNetworkCallsDelegate

@optional
-(void)serviceResultsBadges:(Badges*)badges;
-(void)serviceResultDeleteBadge:(NSDictionary*)result;
-(void)serviceResultsSaveImageBadge:(NSDictionary*)result;
-(void)serviceResultsCreateEditBadge:(NSDictionary*)result;
-(void)serviceResultAwardBadge:(NSDictionary*)result;
-(void)serviceResultRevokeBadge:(NSDictionary*)result;
-(void)serviceResultOpenBadge:(BadgeOpenDetails*)result;
-(void) errorOccuredWithObject : (ErrorObject*) errorObject;

@end

@interface BadgesNetworkCalls : BaseNetwork

-(void) getBadges:(id<BadgesNetworkCallsDelegate>) delegate :(NSString*)requestAddress;
-(void) deleteBadge:(id<BadgesNetworkCallsDelegate>) delegate :(NSString*)requestAddress;
-(void) uploadImageBadge:(id<BadgesNetworkCallsDelegate>) delegate :(NSString*)requestAddress :(NSMutableDictionary*)postParams;
-(void) createEditBadge:(id<BadgesNetworkCallsDelegate>) delegate :(NSString*)requestAddress :(NSMutableDictionary*)postParams;
-(void) revokeBadge:(id<BadgesNetworkCallsDelegate>)delegate :(NSString*)requestAddress;
-(void) awardBadge:(id<BadgesNetworkCallsDelegate>)delegate :(NSString*)requestAddress;
-(void) openBadge:(id<BadgesNetworkCallsDelegate>)delegate :(NSString*)requestAddress;

@end
