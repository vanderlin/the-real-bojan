//
//  AppDelegate.m
//  The Real Bojan
//
//  Created by Todd Vanderlin on 11/28/17.
//  Copyright © 2017 Todd Vanderlin. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

// -------------------------------------------------------
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"1bbf29be3c9e4161b52a70fe93db2703"];
	// Do some additional configuration if needed here
	[[BITHockeyManager sharedHockeyManager] startManager];
	[[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];

	// Override point for customization after application launch.
	// Use Firebase library to configure APIs
	[FIRApp configure];
	
	[[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
	
	[GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
	[GIDSignIn sharedInstance].delegate = self;
	return YES;
}

// -------------------------------------------------------
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
	// ...
	NSLog(@"user sign in %@", user);
	
	if (error == nil) {
		GIDAuthentication *authentication = user.authentication;
		FIRAuthCredential *credential =
		[FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken
										 accessToken:authentication.accessToken];
		
		[[FIRAuth auth] signInWithCredential:credential
								  completion:^(FIRUser *user, NSError *error) {
									  if (error) {
										  // ...
										  return;
									  }
									  // User successfully signed in. Get user data from the FIRUser object
									  // ...
								  }];
		// ...
	} else {
		// ...
	}
}

// -------------------------------------------------------
- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
	// Perform any operations when the user disconnects from app here.
	// ...
}

// -------------------------------------------------------
- (BOOL)application:(nonnull UIApplication *)application
			openURL:(nonnull NSURL *)url
			options:(nonnull NSDictionary<NSString *, id> *)options {
	NSString *sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey];
	return [[FUIAuth defaultAuthUI] handleOpenURL:url sourceApplication:sourceApplication];
	
	NSLog(@"sceme %@", [url scheme]);
	if(3) {
		return [[FBSDKApplicationDelegate sharedInstance] application:application
															  openURL:url
													sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
														   annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
	}
	if (4) {
		return [[GIDSignIn sharedInstance] handleURL:url
								   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
										  annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
	}
}

// -------------------------------------------------------
- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

// -------------------------------------------------------
- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

// -------------------------------------------------------
- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

// -------------------------------------------------------
- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

// -------------------------------------------------------
- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// -------------------------------------------------------
+(AppDelegate*)getInstance {
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
