//
//  RealBojanViewController.h
//  The Real Bojan
//
//  Created by Todd Vanderlin on 11/28/17.
//  Copyright © 2017 Todd Vanderlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggableView.h"
#import "Bojan.h"
#import "AppUtils.h"
#import "GameTimer.h"
#import "ResultsViewController.h"
#import <AudioToolbox/AudioServices.h>


@import Firebase;

@interface RealBojanViewController : UIViewController <DraggableViewDelegate, GameTimerDelegate, UINavigationControllerDelegate> {
	NSInteger cardsLoadedIndex;
	NSMutableArray * loadedCards;
	NSMutableArray * allCards;
	NSInteger score;
	NSInteger gameSeconds;
	SystemSoundID themeAudioID;
	BOOL didEndGame;
}
@property (nonatomic, strong) FIRDatabaseReference * ref;
@property (nonatomic, strong) GameTimer * gameTimer;
@property (nonatomic, retain) NSMutableArray * data;
@property (nonatomic, retain) IBOutlet UILabel * scoreLabel;
@property (nonatomic, retain) IBOutlet UILabel * timerLabel;
@property (nonatomic, retain) IBOutlet UIView * scoreView;
@property (nonatomic, retain) IBOutlet UIView * timeSelectView;
@property (nonatomic, retain) IBOutlet UIButton * realButton;
@property (nonatomic, retain) IBOutlet UIButton * fakeButton;

-(IBAction)realButtonAction:(id)sender;
-(IBAction)fakeButtonAction:(id)sender;

-(IBAction)resetGameAction:(id)sender;
-(IBAction)gameTimeSelectedAction:(id)sender;
-(void)startGameWithTime:(NSInteger)seconds;

@end
