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

@interface AppViewController : UIViewController <GIDSignInUIDelegate> {
	
}
-(IBAction)openGame:(id)sender;
-(IBAction)login:(id)sender;
@property(nonatomic, strong) IBOutlet UIButton * loginButton;
@property(nonatomic, strong) IBOutlet UIButton * playButton;
@end
