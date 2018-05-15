//
//  OpenBadgeViewController.m
//  schoox
//
//  Created by Kostas Stamatis on 24/10/2017.
//  Copyright © 2017 Schoox. All rights reserved.
//

#import "OpenBadgeViewController.h"
#import "Utils.h"

@interface OpenBadgeViewController () < BadgesNetworkCallsDelegate >

@end

@implementation OpenBadgeViewController

#pragma mark -
#pragma mark -View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.awardButton.layer.cornerRadius = 6;
    self.containerIpadView.layer.cornerRadius = 8.0;
    self.containerIpadView.layer.masksToBounds = YES;
    NSData *gifData=[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"indicator" ofType:@"gif"]];
    self.loadingIndicator.image=[UIImage animatedImageWithAnimatedGIFData:gifData];
    self.loadingIndicator.hidden = NO;
    self.openBadgeContainerView.hidden = YES;
    [self setupColorScheme];
    [self networkCalls];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Mint sharedInstance] leaveBreadcrumb:NSStringFromClass([self class])];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Error handling functions

-(void) errorOccuredWithObject : (ErrorObject*) errorObject
{
    [self.awardButton setUserInteractionEnabled:YES];
    switch ([errorObject.errorId integerValue]) {
        case 1://network error
            [self.crouton setText:[Utils getTextMobile:@"Network Error"]];
            break;
        case 2://no internet
            [self.crouton setText:[Utils getTextMobile:@"No internet"]];
            break;
        case 3://JsonParseError
            [self.crouton setText:[Utils getTextMobile:@"Network Error"]];
            break;
        case 4://error deserializing json
            [self.crouton setText:[Utils getTextMobile:@"Network Error"]];
            break;
        case 5://JSON contains error field
            [self.crouton setText:[Utils getTextMobile:@"Network Error"]];
            break;
        default://smt else
            [self.crouton setText:[Utils getTextMobile:@"Network Error"]];
            break;
    }
    if([self.crouton isHidden])
        [self revealErrorMsg];
    
}

-(void) revealErrorMsg
{
    self.crouton.hidden=NO;
    self.croutonTopSpace.constant = -self.crouton.frame.size.height;
    [self.view layoutIfNeeded];
    self.croutonTopSpace.constant = 0;
    [UIView animateWithDuration:1 animations:^{
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished){
        if(finished)
            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hideErrorMsg) userInfo:nil repeats:NO];
    }];
}

-(void) hideErrorMsg
{
    self.croutonTopSpace.constant = -self.crouton.frame.size.height;
    [UIView animateWithDuration:1 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished)
     {
         [self.crouton setHidden:YES];
     }];
}

#pragma mark -
#pragma mark - Utils methods

-(void)setupColorScheme
{
    [self.badgeTypeLabel setTextColor:[ColourHandler basicGreyFontColor]];
    [self.badgeDescription setTextColor:[ColourHandler basicGreyFontColor]];
    [self.badgeTitle setTextColor:[ColourHandler basicBlackFontColor]];
    [self.numOfAwardsLabel setTextColor:[ColourHandler basicBlackFontColor]];
    
}

-(void)showAwardButton:(BadgeOpenDetails*)badge
{
    if (!badge.hasEarnedThisBadge) {
        if ([badge.awardable isEqualToNumber:[NSNumber numberWithInt:2]]) {
            if (badge.alreadyAwarded) {
                [self.awardButton setTitle:[Utils getTextMobile:@"Revoke Badge"] forState:UIControlStateNormal];
                self.badgeAward = NO;
                [self.awardButton setBackgroundColor:[ColourHandler basicGreyFontColor]];
            }else{
                [self.awardButton setTitle:[Utils getTextMobile:@"Award Badge"] forState:UIControlStateNormal];
                self.badgeAward = YES;
                [self.awardButton setBackgroundColor:[ColourHandler blueBasicButtonColor]];
            }
        }else{
            if (badge.canAwarded) {
                [self.awardButton setTitle:[Utils getTextMobile:@"Award Badge"] forState:UIControlStateNormal];
                self.badgeAward = YES;
                [self.awardButton setBackgroundColor:[ColourHandler blueBasicButtonColor]];
            }
            if (badge.alreadyAwarded) {
                [self.awardButton setTitle:[Utils getTextMobile:@"Revoke Badge"] forState:UIControlStateNormal];
                self.badgeAward = NO;
                [self.awardButton setBackgroundColor:[ColourHandler basicGreyFontColor]];
            }
            else if (!badge.canAwarded && !badge.alreadyAwarded){
                [self.awardButton setHidden:YES];
            }
        }
    }else{
        if (badge.alreadyAwarded) {
            [self.awardButton setTitle:[Utils getTextMobile:@"Revoke Badge"] forState:UIControlStateNormal];
            self.badgeAward = NO;
            [self.awardButton setBackgroundColor:[ColourHandler basicGreyFontColor]];
        }else if (!badge.alreadyAwarded){
            [self.awardButton setTitle:[Utils getTextMobile:@"Award Badge"] forState:UIControlStateNormal];
            self.badgeAward = YES;
            [self.awardButton setBackgroundColor:[ColourHandler blueBasicButtonColor]];
        }
    }
}

-(void) networkCalls
{
    self.badgesNetworkCalls = [[BadgesNetworkCalls alloc] init];
    NSString *requestString ;
    [self.badgesNetworkCalls openBadge:self :requestString];
}

#pragma mark -
#pragma mark - ServiceResults

-(void)serviceResultOpenBadge:(BadgeOpenDetails *)result
{
    [self.loadingIndicator setHidden:YES];
    [self.openBadgeContainerView setHidden:NO];
    [self.badgeImageView sd_setImageWithURL:[NSURL URLWithString:result.thumb] placeholderImage:[UIImage imageNamed:@"createBadgeIcon"]];
    self.badgeDescription.text = result.openDetailsDescription;
    self.badgeTypeLabel.text = [NSString stringWithFormat:@"%@ %@",[Utils getTextMobile:@"By"],[Utils getTextMobile:result.ownerType]];
    self.badgeTitle.text = result.title;
    NSString *memberString = [Utils getTextMobile:@"members"];
    if ([result.NumOfAwards isEqualToNumber:[NSNumber numberWithInt:1]]) {
        memberString = [Utils getTextMobile:@"member"];
    }
    self.numOfAwardsLabel.text = [NSString stringWithFormat:@"%@ %@ %@",[Utils getTextMobile:@"Awarded by"],[result.NumOfAwards stringValue],memberString];
    [self showAwardButton:result];
}

-(void)serviceResultAwardBadge:(NSDictionary *)result
{
    [self.awardButton setUserInteractionEnabled:YES];
    [self.awardButton setTitle:[Utils getTextMobile:@"Revoke Badge"]  forState:UIControlStateNormal];
    self.badgeAward = NO;
    [self.awardButton setBackgroundColor:[ColourHandler basicGreyFontColor]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)serviceResultRevokeBadge:(NSDictionary *)result
{
    [self.awardButton setUserInteractionEnabled:YES];
    [self.awardButton setTitle:[Utils getTextMobile:@"Award Badge"] forState:UIControlStateNormal];
    self.badgeAward = YES;
    [self.awardButton setBackgroundColor:[ColourHandler blueBasicButtonColor]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - Buttons Actions

- (IBAction)goBack:(id)sender {
    [self.badgeController hidePopoverBackground];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)AwardRevokeBadge:(id)sender {
    if (self.badgeAward) {
       [self.awardButton setUserInteractionEnabled:NO];
        NSString *requestString ;
        [self.badgesNetworkCalls awardBadge:self :requestString];
    }else{
        [self.awardButton setUserInteractionEnabled:NO];
        NSString *requestString ;
        [self.badgesNetworkCalls revokeBadge:self :requestString];
    }
}

@end
