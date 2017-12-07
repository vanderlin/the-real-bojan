//
//  MenuViewController.m
//  Created by lukasz karluk on 12/12/11.
//

#import "AppViewController.h"
#import "RealBojanViewController.h"
#import "AppDelegate.h"
#import "AppUtils.h"

@import FirebaseGoogleAuthUI;
@import FirebaseFacebookAuthUI;

@interface AppViewController()
@end

@implementation AppViewController

//--------------------------------------------------------------
-(void)viewDidLoad {
	[super viewDidLoad];
	
	
	_logoutButton.alpha = 0;
	
	coverView = [[UIView alloc] initWithFrame:self.view.frame];
	coverView.backgroundColor = [UIColor blackColor];
	coverView.alpha = 0;
	[self.view addSubview:coverView];
	_authUI = [FUIAuth defaultAuthUI];
	_authUI.delegate = self;
	
	NSArray<id<FUIAuthProvider>> *providers = @[[[FUIGoogleAuth alloc] init], [[FUIFacebookAuth alloc] init]];
	_authUI.providers = providers;
	_authUI.signInWithEmailHidden = YES;

	
	[[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user) {
		[self updateAuthButtonsWithUser:user];
		NSLog(@"auth state did change %@", user);
	}];
	
	
	POPLayerSetScaleXY(self.logoView.layer, CGPointZero);
	POPLayerSetScaleXY(self.signInButton.layer, CGPointZero);
	POPLayerSetScaleXY(self.playButton.layer, CGPointZero);
}

//--------------------------------------------------------------
-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	POPLayerSetScaleXY(self.logoView.layer, CGPointZero);
	POPLayerSetScaleXY(self.signInButton.layer, CGPointZero);
	POPLayerSetScaleXY(self.playButton.layer, CGPointZero);
}

//--------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	NSLog(@"view did appear");
	
	[self.logoView bounceInWithDelay:0 didComplete:nil];
	[self.signInButton bounceInWithDelay:0.2 didComplete:nil];
	[self.playButton bounceInWithDelay:0.5 didComplete:nil];
	
	if([FIRAuth auth].currentUser) {
		NSLog(@"current user %@", [FIRAuth auth].currentUser);
		_signInButton.alpha = 0;
	}
	else {
		_signInButton.alpha = 1;
		//_playButton.alpha = 0;
	}
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
-(void)didMoveToParentViewController:(UIViewController *)parent {
	coverView.alpha = 0;
	_signInButton.alpha = 1;
}

//--------------------------------------------------------------
- (FUIAuthPickerViewController *)authPickerViewControllerForAuthUI:(FUIAuth *)authUI {
	NSLog(@"auth view controller %@", authUI);
	return [[AuthViewController alloc] initWithNibName:@"AuthViewController" bundle:nil authUI:authUI];
}

//--------------------------------------------------------------
-(IBAction)signInAction:(id)sender {
	NSLog(@"sign in");
	UINavigationController * authViewController = [_authUI authViewController];
	authViewController.view.backgroundColor = self.view.backgroundColor;
	[self presentViewController:authViewController animated:YES completion:nil];
}

//--------------------------------------------------------------
-(void)updateAuthButtonsWithUser:(FIRUser*)user {
	if(user) {
		[_signInButton fadeToAlpha:0 speed:0.2 delay:0 onComplete:^{
			[_logoutButton fadeToAlpha:1 speed:0.2 delay:0 onComplete:nil];
		}];
	}
	else {
		[_logoutButton fadeToAlpha:0 speed:0.2 delay:0 onComplete:^{
			[_signInButton fadeToAlpha:1 speed:0.2 delay:0 onComplete:nil];
		}];
	}
}

//--------------------------------------------------------------
-(void)authUI:(FUIAuth *)authUI didSignInWithUser:(FIRUser *)user error:(NSError *)error {
	if(user) {
		[self updateAuthButtonsWithUser:user];
		NSLog(@"auth user %@ %@", user.displayName, user.uid);
	}
	NSLog(@"didSignInWithUser %@", user);
}

//--------------------------------------------------------------
-(IBAction)logoutAction:(id)sender {
	NSError * error;
	[self.authUI signOutWithError:&error];
	if (error) {
		NSLog(@"%@", error.localizedDescription);
	}
}
@end
