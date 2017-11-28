//
//  CircleGameViewController.m
//  The Real Bojan
//
//  Created by Todd Vanderlin on 11/22/17.
//

#import "CircleGameViewController.h"
#import "CircleView.h"
#import "AppUtils.h"
@interface CircleGameViewController ()

@end

@implementation CircleGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	float circleW = 50;
	CircleView * v = [[CircleView alloc] initWithFrame:CGRectMake((ViewWidth-circleW)/2, 100, circleW, circleW)];
	
	[self.view addSubview:v];
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
