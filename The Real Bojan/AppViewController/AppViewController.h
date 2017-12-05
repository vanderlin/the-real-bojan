//
//  AppViewController.h
//  The Real Bojan
//
//  Created by Todd Vanderlin on 11/28/17.
//  Copyright © 2017 Todd Vanderlin. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import GoogleSignIn;
@import FirebaseAuthUI;
#import "AuthViewController.h"

@interface AppViewController : UIViewController <FUIAuthDelegate> {
	UIView * coverView;
}
-(IBAction)openGame:(id)sender;
-(IBAction)signInAction:(id)sender;
@property (nonatomic) FUIAuth * authUI;
@property(nonatomic, strong) IBOutlet UIButton * signInButton;
@end
