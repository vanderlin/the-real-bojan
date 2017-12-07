//
//  ResultsViewController.h
//  The Real Bojan
//
//  Created by Todd Vanderlin on 12/1/17.
//  Copyright © 2017 Todd Vanderlin. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@interface ResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableDictionary * sections;
	
}
-(void)setGameResultsScore:(NSInteger)score gameTime:(NSInteger)time;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, retain) IBOutlet UILabel * scoreLabel;
@property (nonatomic, retain) IBOutlet UILabel * timeLabel;
@property (nonatomic, retain) IBOutlet UITableView * tableView;
@property (strong, nonatomic) FIRDatabaseReference *ref;
-(IBAction)playAgainAction:(id)sender;
@end
