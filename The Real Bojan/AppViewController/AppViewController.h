//
//  AppViewController.h
//  The Real Bojan
//
//  Created by Todd Vanderlin on 11/28/17.
//  Copyright © 2017 Todd Vanderlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthViewController.h"
#import "AppUtils.h"
@import pop;
@import Firebase;
@import GoogleSignIn;
@import FirebaseAuthUI;

@interface AppViewController : UIViewController <FUIAuthDelegate> {
	UIView * coverView;
}
-(IBAction)openGame:(id)sender;
-(IBAction)signInAction:(id)sender;
-(IBAction)logoutAction:(id)sender;
@property (nonatomic) FUIAuth * authUI;
@property (nonatomic, strong) IBOutlet UIImageView * logoView;
@property(nonatomic, strong) IBOutlet UIButton * signInButton;
@property(nonatomic, strong) IBOutlet UIButton * playButton;
@property(nonatomic, strong) IBOutlet UIButton * logoutButton;
@end
