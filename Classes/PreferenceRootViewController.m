    //
//  PreferenceRootViewController.m
//  MasterMind
//
//  Created by minidam on 11/07/25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PreferenceRootViewController.h"

@interface PreferenceRootViewController ()

@property(assign) enum PreferenceState state;
@property(retain) NSArray* cellGroupList;

- (void)buildCellGroup;
- (void)onSelectBallsCell: (TableViewCell*)cell;
- (void)onSelectGotoSiteCell: (TableViewCell*)cell;
- (void)onSelectGotoTravelCell: (TableViewCell*)cell;

@end

@implementation PreferenceRootViewController

@synthesize state=state_;
@synthesize ballsCell=ballsCell_;
@synthesize ballsLabel=ballsLabel;
@synthesize balls=balls_;
@synthesize cellGroupList=cellGroupList_;
@synthesize doneButton=doneButton_;
@synthesize ballsViewController=ballsViewController_;
@synthesize startAnimationSwitch=startAnimationSwitch_;
@synthesize backAnimationSwitch=backAnimationSwitch_;
@synthesize done=done_;
@synthesize gotoSiteCell=gotoSiteCell_;
@synthesize gotoTravelCell=gotoTravelCell_;
@synthesize startAnimationCell=startAnimationCell_;
@synthesize backAnimationCell=backAnimationCell_;
@synthesize versionView=versionView_;
@synthesize versionLabel=versionLabel_;

- (id)init{
	if((self = [super init]) != nil){
		[[NSBundle mainBundle] loadNibNamed: @"PreferenceRootViewController"
									  owner: self
									options: nil
		 ];
		// テーブルの構築
		[self buildCellGroup];
		
		self.versionLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
		
		// init直後はballsLabelができていなくて設定できていないらしい...
		self.ballsLabel.text = [NSString stringWithFormat: @"%d", self.balls];
		
		// ナビゲーションバーのセットアップ
		// タイトル
		self.navigationItem.title = @"設定";
		
		// 「完了」ボタン
		//self.navigationItem.leftBarButtonItem = self.doneButton;
		self.navigationItem.rightBarButtonItem = self.doneButton;
	}
	return self;
}

/*
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.state = kPreferenceStateRoot;
    }
    return self;
}
 */

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
 */

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

- (void)viewDidAppear:(BOOL)animated{
	switch(self.state){
		case kPreferenceStateBalls:
			// ボール選択完了後
			self.balls = self.ballsViewController.balls;
			break;
	}
	self.state = kPreferenceStateRoot;
	[super viewDidAppear: animated];
}

- (void)viewDidDisappear:(BOOL)animated{
	switch(self.state){
		case kPreferenceStateBallsShowing:
			self.state = kPreferenceStateBalls;
			break;
	}
	[super viewDidDisappear: animated];
}

- (void)dealloc {
	self.ballsCell = nil;
	self.ballsLabel = nil;
	self.done = nil;
	self.cellGroupList = nil;
	self.doneButton = nil;
	self.ballsViewController = nil;
	self.gotoSiteCell = nil;
	self.gotoTravelCell = nil;
	self.startAnimationCell = nil;
	self.backAnimationCell = nil;
	self.startAnimationSwitch = nil;
	self.backAnimationSwitch = nil;
	self.versionView = nil;
	self.versionLabel = nil;
	
    [super dealloc];
}


- (BOOL)startAnimation{
	return self.startAnimationSwitch.on;
}

- (void)setStartAnimation:(BOOL)startAnimation{
	self.startAnimationSwitch.on = startAnimation;
}

- (BOOL)backAnimation{
	return self.backAnimationSwitch.on;
}

- (void)setBackAnimation:(BOOL)backAnimation{
	self.backAnimationSwitch.on = backAnimation;
}


//// テーブル関係の処理

- (void)buildCellGroup{
	self.cellGroupList = 
	[NSArray arrayWithObjects:
	 [TableViewCellGroup cellGroupTitle: @"ゲームの設定"
								  cells:
	  [TableViewCell cellFor: self.ballsCell
				  didClicked: ^(TableViewCell* cell){
					  [self onSelectBallsCell: cell];
				  }
	   ],
	  nil
	  ],
	 /*
	  // バグることが多いので、アニメーションは省略できないようにする。
	 [TableViewCellGroup cellGroupTitle: @"アニメーションの設定"
								  cells:
	  [TableViewCell cellFor: self.startAnimationCell],
	  [TableViewCell cellFor: self.backAnimationCell],
	  nil
	  ],
	  */
	 [TableViewCellGroup cellGroupTitle: nil
							 footerView: self.versionView
								  cells:
	  [TableViewCell cellFor: self.gotoSiteCell
				  didClicked: ^(TableViewCell* cell){
					  [self onSelectGotoSiteCell: cell];
				  }
	   ],
	  [TableViewCell cellFor: self.gotoTravelCell
				  didClicked: ^(TableViewCell* cell){
					  [self onSelectGotoTravelCell: cell];
				  }
	   ],
	  nil
	  ],
	 nil
	 ];
}


// セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return [self.cellGroupList count];
}

// テーブルに表示する行数
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
	if(section < 0 || [self.cellGroupList count] <= section){
		return 0;
	}
	TableViewCellGroup* cellGroup = [self.cellGroupList objectAtIndex: section];
	return [cellGroup.cellList count];
}

// タイトル
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section{
	TableViewCellGroup* cellGroup = [self.cellGroupList objectAtIndex: section];
	return cellGroup.title;
}

// フッタ
- (UIView *)tableView:(UITableView *)tableView
viewForFooterInSection:(NSInteger)section{
	TableViewCellGroup* cellGroup = [self.cellGroupList objectAtIndex: section];
	return cellGroup.footerView;
}

// フッタの高さ
-  (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section{
	TableViewCellGroup* cellGroup = [self.cellGroupList objectAtIndex: section];
	return (cellGroup.footerView != nil)?cellGroup.footerView.frame.size.height:0;
}

// 表示するセル
- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSInteger section  = indexPath.section;
	NSInteger index = indexPath.row;
	TableViewCellGroup* cellGroup = [self.cellGroupList objectAtIndex: section];
	TableViewCell* cell = [cellGroup.cellList objectAtIndex: index];
	return cell.cell;
}

// セル押下時の処理
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSInteger section  = indexPath.section;
	NSInteger index = indexPath.row;
	
	TableViewCellGroup* cellGroup = [self.cellGroupList objectAtIndex: section];
	TableViewCell* cell = [cellGroup.cellList objectAtIndex: index];
	if(cell.didClicked != nil){
		(cell.didClicked)(cell);
		[tableView deselectRowAtIndexPath: indexPath animated: YES];
	}else{
		// デフォルトの挙動
		[tableView deselectRowAtIndexPath: indexPath animated: YES];
	}
}

- (void)setBalls:(NSInteger)balls{
	if(balls_ == balls){
		return;
	}
	balls_ = balls;
	self.ballsLabel.text = [NSString stringWithFormat: @"%d", balls];
}

// 玉の数を選択した
- (void)onSelectBallsCell: (TableViewCell*)cell{
	self.state = kPreferenceStateBallsShowing;
	self.ballsViewController.balls = self.balls;
	[self.navigationController pushViewController: self.ballsViewController
										 animated: YES
	 ];
}

// サポートサイトへ
- (void)onSelectGotoSiteCell: (TableViewCell*)cell{
	[[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"http://iapp.ikedam.jp/MasterMind/"]];
}

// イケダム係長旅行記へ
- (void)onSelectGotoTravelCell: (TableViewCell*)cell{
	[[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"http://www.ikedam.jp/"]];
}

-(IBAction)donePressed: (id)sender{
	if(self.done != nil){
		(self.done)();
	}
}



@end
