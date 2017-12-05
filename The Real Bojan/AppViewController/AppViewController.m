//
//  MenuViewController.m
//  Created by lukasz karluk on 12/12/11.
//

#import "AppViewController.h"
#import "RealBojanViewController.h"
#import "AppDelegate.h"
#import "AppUtils.h"

@interface AppViewController()
@end

@implementation AppViewController

//--------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	NSLog(@"view did load");
	
	coverView = [[UIView alloc] initWithFrame:self.view.frame];
	coverView.backgroundColor = [UIColor blackColor];
	coverView.alpha = 0;
	[self.view addSubview:coverView];
	
	if([FIRAuth auth].currentUser) {
		NSLog(@"current user %@", [FIRAuth auth].currentUser);
		_loginButton.alpha = 0;
		_playButton.alpha = 1;
	}
	else {
		_loginButton.alpha = 1;
		_playButton.alpha = 0;
	}
	
	
	[[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user) {
		if(user) {
			[UIView animateWithDuration:1.2 animations:^{
				self.playButton.alpha = 1;
				[self openGame:nil];
			}];
			NSLog(@"auth user %@ %@", user.displayName, user.uid);
		}
		NSLog(@"auth state did change %@", user);
	}];
	
	
}

//--------------------------------------------------------------
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

//--------------------------------------------------------------
-(IBAction)openGame:(id)sender {
	//GameViewController * vc = [[GameViewController alloc] init];
	//CircleGameViewController * vc = [[CircleGameViewController alloc] init];
	[coverView fadeToAlpha:1 speed:0.12 delay:0 onComplete:nil];
	
	RealBojanViewController * vc = [[RealBojanViewController alloc] initWithNibName:@"RealBojanViewController" bundle:nil];
	UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:vc];
	[nvc setNavigationBarHidden:YES];
	
	//[self.navigationController pushViewController:nvc animated:YES];
	[self presentViewController:nvc animated:YES completion:nil];
}

//--------------------------------------------------------------
-(IBAction)login:(id)sender {
	NSLog(@"login");
//	[GIDSignIn sharedInstance].delegate = self;
	[GIDSignIn sharedInstance].uiDelegate = self;
	[[GIDSignIn sharedInstance] signIn];
	
}

@end
