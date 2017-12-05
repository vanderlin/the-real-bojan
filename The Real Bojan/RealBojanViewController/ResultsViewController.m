//
//  ResultsViewController.m
//  The Real Bojan
//
//  Created by Todd Vanderlin on 12/1/17.
//  Copyright © 2017 Todd Vanderlin. All rights reserved.
//

#import "ResultsViewController.h"
#import "RealBojanViewController.h"
@import pop;

@interface ResultsViewController ()

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.alpha = 0;
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	POPLayerSetScaleXY(self.scoreLabel.layer, CGPointZero);

	NSLog(@"set game results");
	
	self.scoreLabel.text = [NSString stringWithFormat:@"%i", self.score];
	self.timeLabel.text = [NSString stringWithFormat:@"%i SECONDS", self.time];
	self.ref = [[[FIRDatabase database] reference] child:@"/leaderboard"];
	
	self.tableView.alpha = 1;
	sections = [NSMutableDictionary new];
	BOOL didLoadData = NO;
	[self.ref observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		NSLog(@"Section: %@", snapshot.key);
		NSString * sectionKey = [[snapshot.key stringByReplacingOccurrencesOfString:@"_" withString:@" "] uppercaseString];
		
		if([self hasSection:sectionKey] == NO) {
			[sections setObject:[NSMutableArray array] forKey:sectionKey];
		}
		
		NSEnumerator *children = [snapshot children];
		FIRDataSnapshot *child;
		while (child = [children nextObject]) {
			NSLog(@"snap %@", child.value);
			[self addScoreToSectionName:sectionKey data:child.value];
		}
		if(!didLoadData) {
			[UIView animateWithDuration:0.2 animations:^{
				self.tableView.alpha = 1;
			}];
			__block didLoadData = YES;
		}
		[self.tableView reloadData];
	}];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	POPSpringAnimation *anmB = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
	anmB.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)];
	anmB.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
	anmB.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
	anmB.springBounciness = 20;
	[self.scoreLabel pop_addAnimation:anmB forKey:@"springAnimation"];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// -------------------------------------------------------
-(void)setGameResultsScore:(NSInteger)score gameTime:(NSInteger)time {
	self.score = score;
	self.time = time;
}

// -------------------------------------------------------
-(void)addScoreToSectionName:(NSString*)sectionName data:(NSDictionary*)data {
	
	if([sections objectForKey:sectionName]) {
		NSMutableArray * items = [sections objectForKey:sectionName];
		[items addObject:data];
	}
}

// -------------------------------------------------------
-(BOOL)hasSection:(NSString*)sectionName {
	for (NSString * key in [sections allKeys]) {
		if ([key isEqualToString:sectionName]) {
			return YES;
		}
	}
	return NO;
}

-(NSMutableArray*)dataForSectionIndex:(NSInteger)index {
	NSString * sectionName = [sections.allKeys objectAtIndex:index];
	NSMutableArray * data = [sections objectForKey:sectionName];
	NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
	[data sortUsingDescriptors:@[descriptor]];
	return data;
}

// -------------------------------------------------------
-(NSDictionary*)dataForIndexPath:(NSIndexPath*)indexPath {
	NSMutableArray * data = [self dataForSectionIndex:indexPath.section];
	if(data) {
		return [data objectAtIndex:indexPath.row];
	}
	return nil;
}

// -------------------------------------------------------
-(IBAction)playAgainAction:(id)sender {
	
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source
// -------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [sections.allKeys count];
}

// -------------------------------------------------------
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [sections.allKeys objectAtIndex:section];
}

// -------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSMutableArray * data = [self dataForSectionIndex:section];
	return data.count;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
	view.tintColor = [UIColor colorWithRed:0.11 green:0.11 blue:0.16 alpha:1.00];
	UITableViewHeaderFooterView * v = (UITableViewHeaderFooterView*)view;
	v.textLabel.font = [UIFont fontWithName:@"FredokaOne-Regular" size:v.textLabel.font.pointSize];
	v.textLabel.textColor = [UIColor whiteColor];
	
	tableView.backgroundColor = [UIColor clearColor];
}

// -------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString * cellId = @"results-table-view-cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	NSDictionary * data = [self dataForIndexPath:indexPath];
	
	if(!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
		
		UIColor * lightPurple = [UIColor colorWithRed:0.69 green:0.63 blue:0.74 alpha:1.00];
		UIColor * darkPurple = [UIColor colorWithRed:0.36 green:0.30 blue:0.42 alpha:1.00];
		
		cell.textLabel.font = [UIFont fontWithName:@"FredokaOne-Regular" size:30];
		cell.detailTextLabel.font = [UIFont fontWithName:@"FredokaOne-Regular" size:12];
		
		cell.textLabel.textColor = [UIColor whiteColor];
		cell.detailTextLabel.textColor = [UIColor whiteColor];
		
		cell.backgroundColor = indexPath.row % 2 ? lightPurple : darkPurple;
	}
	
	cell.textLabel.text = [[data objectForKey:@"score"] stringValue];
	cell.detailTextLabel.text = [data objectForKey:@"name"];
	
	return cell;
	
}
@end
