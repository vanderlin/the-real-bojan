//
//  AuthViewController.h
//  The Real Bojan
//
//  Created by Todd Vanderlin on 12/5/17.
//  Copyright © 2017 Todd Vanderlin. All rights reserved.
//

#import <UIKit/UIKit.h>
@import FirebaseAuthUI;

@interface AuthViewController : FUIAuthPickerViewController
-(IBAction)closeAction:(id)sender;
@end
