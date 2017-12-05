//
//  AppDelegate.h
//  The Real Bojan
//
//  Created by Todd Vanderlin on 11/28/17.
//  Copyright © 2017 Todd Vanderlin. All rights reserved.
//

#import <UIKit/UIKit.h>
@import HockeySDK;
@import Firebase;
@import FirebaseAuthUI;
@import GoogleSignIn;

@interface AppDelegate : UIResponder<UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;
+(AppDelegate*)getInstance;
@end

