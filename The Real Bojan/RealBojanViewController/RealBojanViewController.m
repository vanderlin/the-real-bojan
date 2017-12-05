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
	
	// hide all the buttons
	[self hideButtonsAnimated:NO];
	
	self.data = [NSMutableArray new];
	
	loadedCards = [[NSMutableArray alloc] init];
	allCards = [[NSMutableArray alloc] init];
	cardsLoadedIndex = 0;
	
	NSString *directory = [NSString stringWithFormat:@"Faces"];
	NSArray * faceImages = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:directory];
	
	for (NSString * path in faceImages) {
		if ([path containsString:@"@"] == NO) {
			Bojan * bojan = [[Bojan alloc] init];
			bojan.imageName = [NSString stringWithFormat:@"Faces/%@", [path lastPathComponent]];
			bojan.isReal = [[[path lastPathComponent] lowercaseString] containsString:@"real"];
			[self.data addObject:bojan];
			NSLog(@"%@", bojan.imageName);
		}
	}
	
	self.timeSelectView.alpha = 1;
	
	//[[SAMSoundEffect playSoundEffectNamed:@"theme.m4a"] stop];
	//[SAMSoundEffect playSoundEffectNamed:@"theme.m4a"];
	[SoundManager sharedManager].allowsBackgroundMusic = YES;
	[[SoundManager sharedManager] prepareToPlay];
	
	[[SoundManager sharedManager] playMusic:@"theme.m4a" looping:YES fadeIn:YES];
	
	/*NSString *path  = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"m4a"];
	NSURL * pathURL = [NSURL fileURLWithPath : path];
	
	AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &themeAudioID);
	AudioServicesPlaySystemSound(themeAudioID);
	// Using GCD, we can use a block to dispose of the audio effect without using a NSTimer or something else to figure out when it'll be finished playing.
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		AudioServicesDisposeSystemSoundID(themeAudioID);
	});*/
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
	
	//[[SoundManager sharedManager] stopSound:@"theme.m4a" fadeOut:YES];
	[[SoundManager sharedManager] stopMusic:YES];
	
	for (int i = 0; i<[loadedCards count]; i++) {
		[[loadedCards objectAtIndex:i] removeFromSuperview];
	}
	[loadedCards removeAllObjects];
	
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
	
	loadedCards = [[NSMutableArray alloc] init];
	allCards = [[NSMutableArray alloc] init];
	cardsLoadedIndex = 0;
	
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
		// start
		self.gameTimer = [[GameTimer alloc] initWithLongInterval:seconds andShortInterval:1.0/30.0 andDelegate:self];
		[self loadCards];
	}];
}

// -------------------------------------------------------
-(void)loadCards {
	
	NSInteger nData = [self.data count];
	NSInteger numLoadedCardsCap = ((nData > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE:nData);
	[self.data shuffle];

	// load all cards views
	for (int i=0; i<nData; i++) {
		Bojan * bojan = [self.data objectAtIndex:i];
		DraggableView * v = [self createCardWithBojan:bojan];
		[allCards addObject:v];
		if (i < numLoadedCardsCap) {
			[loadedCards addObject:v];
		}
	}
	
	for (int i = 0; i<[loadedCards count]; i++) {
		if (i > 0) {
			[self.view insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
		} else {
			[self.view addSubview:[loadedCards objectAtIndex:i]];
		}
		cardsLoadedIndex++; //%%% we loaded a card into loaded cards, so we have to increment
	}
		
	// start the timer
	[self.gameTimer startTimer];
}
// -------------------------------------------------------
-(DraggableView *)createCardWithBojan:(Bojan*)bojan {
	float x = ([AppDelegate getInstance].window.frame.size.width - CARD_WIDTH)/2;
	float y = ((self.view.frame.size.height - CARD_HEIGHT)/2) + 20;
	float ran = 4;
	x += [AppUtils random:-ran y:ran];
	y += [AppUtils random:-ran y:ran];
	
	CGRect rect = CGRectMake(x, y, CARD_WIDTH, CARD_HEIGHT);
	DraggableView * draggableView = [[DraggableView alloc] initWithFrame:rect withBojan:bojan];
	draggableView.delegate = self;
	return draggableView;
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
	DraggableView *dragView = [loadedCards firstObject];
	dragView.overlayView.mode = GGOverlayViewModeRight;
	[UIView animateWithDuration:0.2 animations:^{
		dragView.overlayView.alpha = 1;
	}];
	[dragView rightClickAction];
}

// fake = left
-(IBAction)fakeButtonAction:(id)sender {
	DraggableView *dragView = [loadedCards firstObject];
	dragView.overlayView.mode = GGOverlayViewModeLeft;
	[UIView animateWithDuration:0.2 animations:^{
		dragView.overlayView.alpha = 1;
	}];
	[dragView leftClickAction];
}

// -------------------------------------------------------
-(void)plusPoints {
	score += POINT_COUNT;
	[SAMSoundEffect playSoundEffectNamed:@"yes-sound.m4a"];
}

-(void)minusPoints {
	score -= POINT_COUNT;
	[SAMSoundEffect playSoundEffectNamed:@"bad-sound.m4a"];
}

#warning include own action here!
//%%% action called when the card goes to the left.
// This should be customized with your own action
// -------------------------------------------------------
-(void)cardSwipedLeft:(UIView *)card; {
	//do whatever you want with the card that was swiped
	DraggableView *c = (DraggableView *)card;
	if (c.bojan.isReal) {
		[self minusPoints];
	}
	else {
		[self plusPoints];
	}
	
	self.scoreLabel.text = [NSString stringWithFormat:@"%i", (int)score];
	
	[loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
	
	if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
		[loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
		cardsLoadedIndex++;//%%% loaded a card, so have to increment count
		[self.view insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
	}
	else {
		[self loadCards];
	}
}

#warning include own action here!
//%%% action called when the card goes to the right.
// This should be customized with your own action
// -------------------------------------------------------
-(void)cardSwipedRight:(UIView *)card {
	//do whatever you want with the card that was swiped
	DraggableView *c = (DraggableView *)card;
	if (c.bojan.isReal) {
		[self plusPoints];
	}
	else {
		[self minusPoints];
	}
	
	self.scoreLabel.text = [NSString stringWithFormat:@"%i", (int)score];
	
	
	[loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
	
	if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
		[loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
		cardsLoadedIndex++;//%%% loaded a card, so have to increment count
		[self.view insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
	} else {
		[self loadCards];
	}
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
	//Time is up
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

@end
