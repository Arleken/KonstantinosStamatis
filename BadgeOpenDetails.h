//
//  BadgeOpenDetails.h
//  schoox
//
//  Created by Kostas Stamatis on 27/10/2017.
//  Copyright © 2017 Schoox. All rights reserved.
//

#import "BaseObject.h"

@interface BadgeOpenDetails : BaseObject

@property (nonatomic , strong)NSNumber *NumOfAwards;
@property (nonatomic , unsafe_unretained)BOOL alreadyAwarded;
@property (nonatomic , strong)NSNumber *awardable;
@property (nonatomic , unsafe_unretained)BOOL canAwarded;
@property (nonatomic , unsafe_unretained)BOOL openDetailsDeleted;
@property (nonatomic , strong)NSString *openDetailsDescription;
@property (nonatomic , unsafe_unretained)BOOL hasEarnedThisBadge;
@property (nonatomic , strong)NSString *ownerType;
@property (nonatomic , strong)NSString *thumb;
@property (nonatomic , strong)NSString *title;

+(BadgeOpenDetails*)deserializeJsonDictionary:(NSDictionary*)jsonDict;

@end
