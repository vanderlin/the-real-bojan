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
		if(user) {
			[self openGame:nil];
			NSLog(@"auth user %@ %@", user.displayName, user.uid);
		}
		NSLog(@"auth state did change %@", user);
	}];
	
	
	POPLayerSetScaleXY(self.logoView.layer, CGPointZero);
	POPLayerSetScaleXY(self.signInButton.layer, CGPointZero);
}

//--------------------------------------------------------------
-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	POPLayerSetScaleXY(self.logoView.layer, CGPointZero);
	POPLayerSetScaleXY(self.signInButton.layer, CGPointZero);
}

//--------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	NSLog(@"view did appear");
	
	POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
	sprintAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)];
	sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
	sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
	sprintAnimation.springBounciness = 20.f;
	[self.logoView pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
	
	[self performBlock:^{
		
		POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
		sprintAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)];
		sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
		sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
		sprintAnimation.springBounciness = 20.f;
		[self.signInButton pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
		
	} afterDelay:0.5];
	
	if([FIRAuth auth].currentUser) {
		NSLog(@"current user %@", [FIRAuth auth].currentUser);
		_signInButton.alpha = 0;
		//_playButton.alpha = 1;
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
	vc.authUI = _authUI;
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
-(void)authUI:(FUIAuth *)authUI didSignInWithUser:(FIRUser *)user error:(NSError *)error {
	if(user) {
		[self openGame:nil];
		NSLog(@"auth user %@ %@", user.displayName, user.uid);
	}
	NSLog(@"auth state did change %@", user);
}

@end
