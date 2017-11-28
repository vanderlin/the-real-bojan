//
//  MenuViewController.h
//  Created by lukasz karluk on 12/12/11.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>

@interface AppViewController : UIViewController <GIDSignInDelegate, GIDSignInUIDelegate> {
	
}
-(IBAction)openGame:(id)sender;
-(IBAction)login:(id)sender;
@property(nonatomic, strong) IBOutlet UIButton * loginButton;
@property(nonatomic, strong) IBOutlet UIButton * playButton;
@end
