//
//  RealBojanViewController.m
//  The Real Bojan
//
//  Created by Todd Vanderlin on 11/28/17.
//  Copyright © 2017 Todd Vanderlin. All rights reserved.
//

#import "RealBojanViewController.h"
#import "AppDelegate.h"

@import SoundManager;
@import SAMSoundEffect;

static const int MAX_BUFFER_SIZE = 2; //%%% max number of cards loaded at any given time, must be greater than 1
static const float CARD_HEIGHT = 390; //%%% height of the draggable card
static const float CARD_WIDTH = 290; //%%% width of the draggable card
static const float POINT_COUNT = 100;

@interface RealBojanViewController ()

@end

@implementation RealBojanViewController

// -------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
	didEndGame = NO;
	self.navigationController.delegate = self;
	
	//for (NSString *familyName in [UIFont familyNames]) { for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) { NSLog(@"%@", fontName); } }
	score = 0;
	self.scoreLabel.text = @"";
	self.scoreView.alpha = 0;
	
	ZLSwipeableView * swipeableView = [[ZLSwipeableView alloc] initWithFrame:CGRectZero];
	self.swipeableView = swipeableView;
	[self.view addSubview:self.swipeableView];
	
	// Required Data Source
	self.swipeableView.dataSource = self;
	
	// Optional Delegate
	self.swipeableView.delegate = self;
	
	self.swipeableView.translatesAutoresizingMaskIntoConstraints = NO;
	NSDictionary *metrics = @{};
	
	[self.view addConstraints:[NSLayoutConstraint
							   constraintsWithVisualFormat:@"|-50-[swipeableView]-50-|"
							   options:0
							   metrics:metrics
							   views:NSDictionaryOfVariableBindings(swipeableView)]];
	
	[self.view addConstraints:[NSLayoutConstraint
							   constraintsWithVisualFormat:@"V:|-120-[swipeableView]-100-|"
							   options:0
							   metrics:metrics
							   views:NSDictionaryOfVariableBindings(swipeableView)]];
	
	self.swipeableView.swipingDeterminator = self;
	self.swipeableView.allowedDirection = ZLSwipeableViewDirectionLeft | ZLSwipeableViewDirectionRight;
	self.swipeableView.userInteractionEnabled = NO;
	self.data = [NSMutableArray new];
	
	NSString *directory = [NSString stringWithFormat:@"Faces"];
	NSArray * faceImages = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:directory];
	
	for (NSString * path in faceImages) {
		if ([path containsString:@"@"] == NO) {
			Bojan * bojan = [[Bojan alloc] init];
			bojan.imageName = [NSString stringWithFormat:@"Faces/%@", [path lastPathComponent]];
			bojan.isReal = [[[path lastPathComponent] lowercaseString] containsString:@"real"];
			[self.data addObject:bojan];
			//NSLog(@"%@", bojan.imageName);
		}
	}
	
	self.timeSelectView.alpha = 1;
	
	// hide all the buttons
	[self hideButtonsAnimated:NO];
	[SoundManager sharedManager].allowsBackgroundMusic = YES;
	[[SoundManager sharedManager] prepareToPlayWithSound:@"yes-sound.m4a"];
	[[SoundManager sharedManager] prepareToPlayWithSound:@"bad-sound.m4a"];

	[[SoundManager sharedManager] prepareToPlay];
	[[SoundManager sharedManager] playMusic:@"theme.m4a" looping:YES fadeIn:YES];

}

#pragma mark - End of Game
// -------------------------------------------------------
-(void)showResults {
	ResultsViewController * vc = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:nil];
	[vc setGameResultsScore:score gameTime:gameSeconds];
	vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self.navigationController pushViewController:vc animated:YES];

}

// -------------------------------------------------------
-(void)endGame {
	didEndGame = YES;
	self.swipeableView.userInteractionEnabled = NO;
	[self.gameTimer stopTimer];
	[[SoundManager sharedManager] stopMusic:YES];
	[self.swipeableView discardAllViews];
	[self hideButtonsAnimated:YES];
	[self postScore:score forGameTime:gameSeconds didComplete:^{
		[self showResults];
	}];

}

#pragma mark - Start Game
// -------------------------------------------------------
-(void)resetGameAction:(id)sender {
	score = 0;
	self.scoreLabel.text = @"";
	self.scoreView.alpha = 0;
	
	[self hideButtonsAnimated:NO];
	
	self.timeSelectView.alpha = 1;
	
	
	
	NSLog(@"reset game");
	didEndGame = NO;
	[[SoundManager sharedManager] playMusic:@"theme.m4a" looping:YES fadeIn:YES];
}

// -------------------------------------------------------
-(void)startGameWithTime:(NSInteger)seconds {
	gameSeconds = seconds;
	[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
		self.timeSelectView.alpha = 0;
	} completion:^(BOOL finished) {
		self.scoreView.alpha = 1;
		[self showButtonsAnimated:YES];
		[self loadCards];
	}];
}

// -------------------------------------------------------
-(void)loadCards {
	self.swipeableView.userInteractionEnabled = YES;
	[self.data shuffle];
	[self.swipeableView discardAllViews];
	[self.swipeableView loadViewsIfNeeded];
	self.gameTimer = [[GameTimer alloc] initWithLongInterval:gameSeconds andShortInterval:1.0/30.0 andDelegate:self];
	[self.gameTimer startTimer];
}

#pragma mark - Post Score
// -------------------------------------------------------
-(void)postScore:(NSInteger)score forGameTime:(NSInteger)seconds didComplete:(BasicBlock)didComplete{

	// post score to leaderboard
	
	/*
	 leaderboard {
		 10_seconds: {
			 user_id: {
				 score: number,
				 timestamp: date
			 }
		 }
		 20_seconds
		 30_seconds
	 }
	*/
	self.ref = [[FIRDatabase database] reference];
	
	// first get the score for this "game time"
	NSString * uid = [FIRAuth auth].currentUser.uid;
	NSString * gameKey = [NSString stringWithFormat:@"%i_seconds", seconds];
	
	[[[[self.ref child:@"leaderboard"] child:gameKey] child:uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		
		// if the value is null then we just post the score
		if([snapshot.value isKindOfClass:[NSNull class]]) {
			
			NSDictionary * post = @{
									@"name": [FIRAuth auth].currentUser.displayName,
									@"score": @(score),
									@"timestamp": [FIRServerValue timestamp]
									};
			NSDictionary * payload = @{[NSString stringWithFormat:@"/leaderboard/%@/%@", gameKey, uid]: post};
			[self.ref updateChildValues:payload];
			NSLog(@"payload %@", payload);
			
			if(didComplete) {
				didComplete();
			}
		}
		else {
			
			NSInteger currentScore = [snapshot.value[@"score"] integerValue];
			NSLog(@"current score is %i", currentScore);
			if (score > currentScore) {
				NSDictionary * post = @{
										@"name": [FIRAuth auth].currentUser.displayName,
										@"score": @(score),
										@"timestamp": [FIRServerValue timestamp]
										};
				NSDictionary * payload = @{[NSString stringWithFormat:@"/leaderboard/%@/%@", gameKey, uid]: post};
				[self.ref updateChildValues:payload];
				NSLog(@"posting new score is %@", post);
			}
			
			if(didComplete) {
				didComplete();
			}
			
		}
			
	}];
	
}

// -------------------------------------------------------
-(void)showButtonsAnimated:(BOOL)animated {
	if(animated) {
		[UIView animateWithDuration:0.3 animations:^{
			self.realButton.alpha = 1;
			self.fakeButton.alpha = 1;
		}];
		
		POPSpringAnimation *anmA = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
		anmA.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)];
		anmA.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
		anmA.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
		anmA.springBounciness = 20.f;
		[self.realButton pop_addAnimation:anmA forKey:@"springAnimation"];
		
		
		POPSpringAnimation *anmB = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
		anmB.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)];
		anmB.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
		anmB.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
		anmB.springBounciness = 20.f;
		[self.fakeButton pop_addAnimation:anmB forKey:@"springAnimation"];
		
	}
	else {
		self.realButton.alpha = 1;
		self.fakeButton.alpha = 1;
	}
}

// -------------------------------------------------------
-(void)hideButtonsAnimated:(BOOL)animated {
	if(animated) {
		[UIView animateWithDuration:0.3 animations:^{
			self.realButton.alpha = 0;
			self.fakeButton.alpha = 0;
		}];
	}
	else {
		self.realButton.alpha = 0;
		self.fakeButton.alpha = 0;
	}
}

// -------------------------------------------------------
-(IBAction)gameTimeSelectedAction:(id)sender {
	UIButton * btn = (UIButton*)sender;
	NSInteger tag = btn.tag;
	NSInteger seconds;
	switch (tag) {
		case 1:
			seconds = 10;
			break;
		case 2:
			seconds = 20;
			break;
		case 3:
			seconds = 30;
			break;
		default:
			seconds = 10;
			break;
	}
	if(self.gameTimer) {
		[self.gameTimer stopTimer];
		self.gameTimer = nil;
	}
	
	[self startGameWithTime:seconds];
}

#pragma mark - Swip Actions
// real = right
// -------------------------------------------------------
-(IBAction)realButtonAction:(id)sender {
	[self.swipeableView swipeTopViewToRight];
}

// fake = left
-(IBAction)fakeButtonAction:(id)sender {
	[self.swipeableView swipeTopViewToLeft];
}

#pragma mark - Points
// -------------------------------------------------------
-(void)plusPoints {
	score += POINT_COUNT;
	
	POPSpringAnimation *anmB = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
	anmB.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.9, 0.9)];
	anmB.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
	anmB.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
	anmB.springBounciness = 15;
	[self.scoreLabel pop_addAnimation:anmB forKey:@"springAnimation"];
	
	//[[SoundManager sharedManager] playMusic:@"yes-sound.m4a" looping:NO];
	[SAMSoundEffect playSoundEffectNamed:@"yes-sound.m4a"];
	self.scoreLabel.text = [NSString stringWithFormat:@"%i", (int)score];
}

-(void)minusPoints {
	score -= POINT_COUNT;
	
	//[[SoundManager sharedManager] playMusic:@"bad-sound.m4a" looping:NO];
	[SAMSoundEffect playSoundEffectNamed:@"bad-sound.m4a"];
	self.scoreLabel.text = [NSString stringWithFormat:@"%i", (int)score];
}

#pragma mark - SwipeableView DataSource
// -------------------------------------------------------
- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
	Bojan * randomBojan = [self.data randomObject];
	float x = (self.swipeableView.frame.size.width - CARD_WIDTH) / 2;
	float y = (self.swipeableView.frame.size.height - CARD_HEIGHT) / 2;
	
	CGRect rect = CGRectMake(x, y, CARD_WIDTH, CARD_HEIGHT);
	CardView * view = [[CardView alloc] initWithFrame:rect withBojan:randomBojan];
	return view;
}

// -------------------------------------------------------
- (BOOL)shouldSwipeView:(UIView *)view movement:(ZLSwipeableViewMovement *)movement swipeableView:(ZLSwipeableView *)swipeableView {
	return YES;
}

#pragma mark - SwipeableView Delegate
// -------------------------------------------------------
- (void)swipeableView:(ZLSwipeableView *)swipeableView didSwipeView:(UIView *)view inDirection:(ZLSwipeableViewDirection)direction {
	NSLog(@"did swipe in direction: %zd", direction);
	CardView * c = (CardView *)view;
	
	// fake = left
	if (direction == ZLSwipeableViewDirectionLeft) {
		if (c.bojan.isReal) {
			[self minusPoints];
		}
		else {
			[self plusPoints];
		}
	}
	
	// real = right
	else if (direction == ZLSwipeableViewDirectionRight) {
		if (c.bojan.isReal) {
			[self plusPoints];
		}
		else {
			[self minusPoints];
		}
	}
}
- (void)swipeableView:(ZLSwipeableView *)swipeableView didCancelSwipe:(UIView *)view {
	NSLog(@"did cancel swipe");
}
- (void)swipeableView:(ZLSwipeableView *)swipeableView didStartSwipingView:(UIView *)view atLocation:(CGPoint)location {
	NSLog(@"did start swiping at location: x %f, y%f", location.x, location.y);
}
- (void)swipeableView:(ZLSwipeableView *)swipeableView swipingView:(UIView *)view atLocation:(CGPoint)location  translation:(CGPoint)translation {
	NSLog(@"swiping at location: x %f, y %f, translation: x %f, y %f", location.x, location.y, translation.x, translation.y);
}
- (void)swipeableView:(ZLSwipeableView *)swipeableView didEndSwipingView:(UIView *)view atLocation:(CGPoint)location {
	NSLog(@"did start swiping at location: x %f, y%f", location.x, location.y);
}

#pragma mark - Nav Controller Delegate
// -------------------------------------------------------
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	if(didEndGame && [viewController isKindOfClass:[RealBojanViewController class]]) {
		NSLog(@"---- parent, %@", [viewController class]);
		didEndGame = NO;
		[self resetGameAction:nil];
	}
}

#pragma mark - Gamer Timers
// -------------------------------------------------------
-(void)longTimerExpired:(GameTimer *)gameTimer {
	[self endGame];
}

// -------------------------------------------------------
-(void)shortTimerExpired:(GameTimer *)gameTimer time:(float)time longInterval:(float)longInterval {
	NSLog(@"timer %f", time);
	int timeRemaining = gameSeconds - time;
	self.timerLabel.text = [NSString stringWithFormat:@"%i", timeRemaining];
}

// -------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Logout
-(IBAction)logoutAction:(id)sender {
	[self.gameTimer stopTimer];
	[[SoundManager sharedManager] stopMusic:YES];
	NSError *error;
	[self.authUI signOutWithError:&error];
	if (error) {
		NSLog(@"%@", error.localizedDescription);
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end
