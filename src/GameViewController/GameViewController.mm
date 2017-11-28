//
//  GameViewController.m
//  bojan
//
//  Created by Todd Vanderlin on 11/22/17.
//

#import "GameViewController.h"
#import "ofxiOSViewController.h"
#include "ofxiOSExtras.h"
#include "ofAppiOSWindow.h"
#import "ofApp.h"


@interface GameViewController ()

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//ofxiOSViewController * vc = [[ofxiOSViewController alloc] initWithFrame:self.view.frame app:new ofApp()];
	//[self.view addSubview:vc.view];
	
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
