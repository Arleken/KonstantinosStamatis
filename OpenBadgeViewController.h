//
//  OpenBadgeViewController.h
//  schoox
//
//  Created by Kostas Stamatis on 24/10/2017.
//  Copyright © 2017 Schoox. All rights reserved.
//

#import "ParentViewController.h"
#import "BadgeEditAwardViewController.h"

@interface OpenBadgeViewController : ParentViewController

@property BadgesNetworkCalls *badgesNetworkCalls;
@property BadgeEditAwardViewController *badgeController;
@property (nonatomic , strong) NSString *userID;
@property (nonatomic , strong) NSNumber *badgeID;
@property (nonatomic , unsafe_unretained)BOOL badgeAward;

@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView;
@property (weak, nonatomic) IBOutlet UILabel *badgeDescription;
@property (weak, nonatomic) IBOutlet UILabel *badgeTitle;
@property (weak, nonatomic) IBOutlet UILabel *numOfAwardsLabel;
@property (weak, nonatomic) IBOutlet UIButton *awardButton;
@property (weak, nonatomic) IBOutlet UILabel *badgeTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *crouton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *croutonTopSpace;
@property (weak, nonatomic) IBOutlet UIImageView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UIView *openBadgeContainerView;
@property (weak, nonatomic) IBOutlet UIView *containerIpadView;

- (IBAction)goBack:(id)sender;
- (IBAction)AwardRevokeBadge:(id)sender;

@end
