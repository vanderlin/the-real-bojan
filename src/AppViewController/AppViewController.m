//
//  MenuViewController.m
//  Created by lukasz karluk on 12/12/11.
//

#import "AppViewController.h"
#import "GameViewController.h"
#import "CircleGameViewController.h"
#import <Firebase.h>
#import <FirebaseAuth/FirebaseAuth.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import "AppUtils.h"

@interface AppViewController()
@end

@implementation AppViewController

//--------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
	[FIRApp configure];
	[GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
	[GIDSignIn sharedInstance].uiDelegate = self;
	[GIDSignIn sharedInstance].delegate = self;
	
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
	}];
	
	
}

//--------------------------------------------------------------
-(void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
	
}

//--------------------------------------------------------------
-(void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
	
}
//--------------------------------------------------------------
-(void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
	if (error == nil) {
		GIDAuthentication *authentication = user.authentication;
		FIRAuthCredential *credential = [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken accessToken:authentication.accessToken];
		
		[[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
			NSLog(@"google signed in user");
		}];
	} else {
		// ...
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
	CircleGameViewController * vc = [[CircleGameViewController alloc] init];
	[self presentViewController:vc animated:YES completion:nil];
}

//--------------------------------------------------------------
-(IBAction)login:(id)sender {
	//LoginViewController * vc = [[LoginViewController alloc] init];
	//[self.navigationController pushViewController:vc animated:YES];
	
//	[GIDSignIn sharedInstance].delegate = self;
	[[GIDSignIn sharedInstance] signIn];
}


//
//
//- (void)loadView {
//    [super loadView];
//
//	/*
//    OFAppViewController * viewController = [[[OFAppViewController alloc] initWithFrame:[[UIScreen mainScreen] bounds] app:new ofApp()] autorelease];
//
//    [self.navigationController setNavigationBarHidden:TRUE];
//    [self.navigationController pushViewController:viewController animated:NO];
//    self.navigationController.navigationBar.topItem.title = @"ofApp";
//
//	UISwipeGestureRecognizer * p = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlePress:)];
//	[viewController.view addGestureRecognizer:p];*/
//}
//
//- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    BOOL bRotate = NO;
//    bRotate = bRotate || (toInterfaceOrientation == UIInterfaceOrientationPortrait);
//    bRotate = bRotate || (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
//    return bRotate;
//}

@end
