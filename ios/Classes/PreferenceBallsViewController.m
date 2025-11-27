    //
//  PreferenceBallsViewController.m
//  MasterMind
//
//  Created by minidam on 11/07/25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PreferenceBallsViewController.h"
#import "Constants.h"
#define kCellIdentifier @"balls"

@interface PreferenceBallsViewController ()

@property(assign) NSInteger min;
@property(assign) NSInteger max;

@end

@implementation PreferenceBallsViewController

@synthesize balls=balls_;
@synthesize min=min_;
@synthesize max=max_;


/*
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
 */

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.min = kBallsMin;
	self.max = kBallsMax;
	self.navigationItem.title = @"玉の数";
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void)setBalls:(NSInteger)balls{
	if(balls_ == balls){
		return;
	}
	balls_ = balls;
	[self.tableView reloadData];
}

// セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

// テーブルに表示する行数
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
	return self.max - self.min + 1;
}

// 表示するセル
- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	//NSInteger section  = indexPath.section;
	NSInteger index = indexPath.row;
	
	// ボールの数
	NSInteger balls = index + self.min;
	
	// 再利用可能なセルがあればそれを使用
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: kCellIdentifier];
	if(cell == nil){
		// 再利用可能なセルがない。新しいのを作る。
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
									   reuseIdentifier: kCellIdentifier
				 ] autorelease];
	}
	cell.accessoryType = (balls==self.balls)?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
	cell.textLabel.text = [NSString stringWithFormat: @"%d", balls];
	return cell;
}

// セル押下時の処理
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	//NSInteger section  = indexPath.section;
	NSInteger index = indexPath.row;
	
	// ボールの数
	NSInteger balls = index + self.min;
	
	self.balls = balls;
	[self.navigationController popViewControllerAnimated: YES];
}

@end
