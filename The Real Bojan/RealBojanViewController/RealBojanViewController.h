//
//  RealBojanViewController.h
//  The Real Bojan
//
//  Created by Todd Vanderlin on 11/28/17.
//  Copyright © 2017 Todd Vanderlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bojan.h"
#import "CardView.h"
#import "AppUtils.h"
#import "GameTimer.h"
#import "ResultsViewController.h"
#import <AudioToolbox/AudioServices.h>
@import pop;
@import Firebase;
@import FirebaseAuthUI;
@import ZLSwipeableView;


@interface RealBojanViewController : UIViewController <ZLSwipeableViewDataSource, ZLSwipeableViewDelegate, ZLSwipeableViewSwipingDeterminator, GameTimerDelegate, UINavigationControllerDelegate> {
	NSInteger score;
	NSInteger gameSeconds;
	BOOL didEndGame;
}
@property (nonatomic, strong) ZLSwipeableView * swipeableView;
@property (nonatomic, strong) FIRDatabaseReference * ref;
@property (nonatomic, retain) GameTimer * gameTimer;
@property (nonatomic, retain) NSMutableArray * data;
@property (nonatomic, retain) IBOutlet UILabel * scoreLabel;
@property (nonatomic, retain) IBOutlet UILabel * timerLabel;
@property (nonatomic, retain) IBOutlet UIView * scoreView;
@property (nonatomic, retain) IBOutlet UIView * timeSelectView;
@property (nonatomic, retain) IBOutlet UIButton * realButton;
@property (nonatomic, retain) IBOutlet UIButton * fakeButton;
@property (nonatomic, retain) FUIAuth * authUI;

-(IBAction)logoutAction:(id)sender;
-(IBAction)realButtonAction:(id)sender;
-(IBAction)fakeButtonAction:(id)sender;

-(IBAction)resetGameAction:(id)sender;
-(IBAction)gameTimeSelectedAction:(id)sender;
-(void)startGameWithTime:(NSInteger)seconds;

@end
