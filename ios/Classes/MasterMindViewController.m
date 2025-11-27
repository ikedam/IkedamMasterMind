//
//  MasterMindViewController.m
//  MasterMind
//
//  Created by minidam on 11/06/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MasterMindViewController.h"
#import "UIBlockAlertView.h"
#import "MasterMindAppDelegate.h"


@interface MasterMindViewController ();

@property(retain) AdMakerView* adMakerView;
@property(retain) GameViewController* gameViewController;	// ゲームのコントローラ
@property(retain) HowtoViewController* howtoViewController;	// 説明画面のコントローラ
@property(retain) ScoreViewController* scoreViewController;	// 成績表時画面のコントローラ
@property(retain) PreferenceController* preferenceController;	// 設定画面のコントローラ
@property(retain) Preference* preference;	// 設定情報
@property(assign) enum AppState state;
@property(retain) NSManagedObjectContext* managedObjectContext;


- (void)showHowto;
- (void)hideHowto;
- (void)showScore;
- (void)hideScore;
- (void)showPreference;
- (void)hidePreference;
- (void)showGame;
- (void)hideGame;

@end

@implementation MasterMindViewController

@synthesize adMakerView=adMakerView_;
@synthesize gameViewController=gameViewController_;
@synthesize howtoViewController=howtoViewController_;
@synthesize scoreViewController=scoreViewController_;
@synthesize preferenceController=preferenceController_;
@synthesize preference=preference_;
@synthesize state=state_;
@synthesize managedObjectContext=managedObjectContext_;
@synthesize startButton=startButton_;
@synthesize restartButton=restartButton_;

- (NSManagedObjectContext*)managedObjectContext{
	if(managedObjectContext_ == nil){
		MasterMindAppDelegate* app = (MasterMindAppDelegate*)[[UIApplication sharedApplication] delegate];
		managedObjectContext_ = [[app managedObjectContext] retain];
	}
	return managedObjectContext_;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	self.state = kAppStateTitle;
	self.gameViewController = [[[GameViewController alloc] init] autorelease];
	self.gameViewController.backToTitle = ^(void){
		[self hideGame];
	};
	self.preference = [[[Preference alloc] initFromDefaults] autorelease];
	self.gameViewController.managedObjectContext = self.managedObjectContext;
	self.gameViewController.preference = self.preference;
	
	// データがある場合はそのデータでゲームを再開。
	if([self.gameViewController recoverGameState]){
		self.state = kAppStateInitGame;
	}
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
	self.managedObjectContext = nil;
	self.preference = nil;
	self.gameViewController = nil;
	self.howtoViewController = nil;
	self.scoreViewController = nil;
	self.preferenceController = nil;
	self.adMakerView = nil;
	self.startButton = nil;
	self.restartButton = nil;
    
    [super dealloc];
}


- (void)setState:(enum AppState)newState{
	enum AppState oldState = self.state;
	
	if(oldState == newState){
		return;
	}
	state_ = newState;
	
	switch(newState){
		case kAppStateTitle:
			break;
		case kAppStateHowtoShowing:
			self.howtoViewController = [[[HowtoViewController alloc] init] autorelease];
			self.howtoViewController.done = ^(void){
				[self hideHowto];
			};
			[self presentModalViewController: self.howtoViewController
									animated: YES
			 ];
			break;
		case kAppStateHowtoHiding:
			[self dismissModalViewControllerAnimated: YES];
			break;
		case kAppStateScoreShowing:
			self.scoreViewController = [[[ScoreViewController alloc] init] autorelease];
			self.scoreViewController.done = ^(void){
				[self hideScore];
			};
			self.scoreViewController.managedObjectContext = self.managedObjectContext;
			self.scoreViewController.preference = self.preference;
			[self presentModalViewController: self.scoreViewController
									animated: YES
			 ];
			break;
		case kAppStateScoreHiding:
			[self dismissModalViewControllerAnimated: YES];
			break;
		case kAppStatePreferenceShowing:
			self.preferenceController = [[[PreferenceController alloc] init] autorelease];
			self.preferenceController.done = ^(void){
				[self hidePreference];
			};
			self.preferenceController.preference = self.preference;
			[self presentModalViewController: self.preferenceController.viewController
									animated: YES
			 ];
			break;
		case kAppStatePreferenceHiding:
			[self dismissModalViewControllerAnimated: YES];
			break;
		case kAppStateGame:
			if(self.adMakerView == nil){
				self.adMakerView = [[[AdMakerView alloc] init] autorelease];
				[self.adMakerView setAdMakerDelegate: self];
				// 最初は枠外に表示
				[self.adMakerView setFrame: self.gameViewController.adBaseView.frame];
				[self.adMakerView start];
			}
			[self.adMakerView viewWillAppear];
			[self presentModalViewController: self.gameViewController
									animated: NO
			 ];
			[self.gameViewController resume];
			break;
	}
	
	 switch(oldState){
		 case kAppStateGame:
			 [self.adMakerView viewWillDisappear];
			 [self dismissModalViewControllerAnimated: NO];
			 break;
	 }
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear: animated];
	switch(self.state){
		case kAppStatePreferenceHiding:
			self.preference = self.preferenceController.preference;
			self.gameViewController.preference = self.preference;
			[self.preference saveDefaults];
			break;
	}
	if([self.gameViewController isSuspended]){
		self.startButton.hidden = YES;
		self.restartButton.hidden = NO;
	}else{
		self.startButton.hidden = NO;
		self.restartButton.hidden = YES;
	}
}

-(void)viewDidAppear:(BOOL)animated{
	switch(self.state){
		case kAppStateInitGame:
			self.state = kAppStateGame;
			break;
		case kAppStatePreferenceHiding:
			self.state = kAppStateTitle;
			self.preferenceController = nil;
			break;
		case kAppStateHowtoHiding:
			self.howtoViewController = nil;
			self.state = kAppStateTitle;
			break;
		case kAppStateScoreHiding:
			self.scoreViewController = nil;
			self.state = kAppStateTitle;
			break;
	}
	[super viewDidAppear: animated];
}

-(void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear: animated];
	switch(self.state){
		case kAppStatePreferenceShowing:
			self.state = kAppStatePreference;
			break;
		case kAppStateHowtoShowing:
			self.state = kAppStateHowto;
			break;
		case kAppStateScoreShowing:
			self.state = kAppStateScore;
			break;
	}
}

/*直下のイベント処理*/
-(IBAction)onGamePressed: (id)sender{
	[self showGame];
}

-(IBAction)onHowtoPressed: (id)sender{
	[self showHowto];
}

-(IBAction)onScorePressed: (id)sender{
	[self showScore];
}

-(IBAction)onPreferencePressed: (id)sender{
	[self showPreference];
}


/* 他のビューのイベント処理 */
- (void)showHowto{
	if(self.state != kAppStateTitle){
		return;
	}
	self.state = kAppStateHowtoShowing;
}

- (void)hideHowto{
	if(self.state != kAppStateHowto){
		return;
	}
	self.state = kAppStateHowtoHiding;
}

- (void)showScore{
	if(self.state != kAppStateTitle){
		return;
	}
	self.state = kAppStateScoreShowing;
}

- (void)hideScore{
	if(self.state != kAppStateScore){
		return;
	}
	self.state = kAppStateScoreHiding;
}

- (void)showPreference{
	if(self.state != kAppStateTitle){
		return;
	}
	self.state = kAppStatePreferenceShowing;
}

- (void)hidePreference{
	if(self.state != kAppStatePreference){
		return;
	}
	self.state = kAppStatePreferenceHiding;
}

- (void)showGame{
	if(self.state != kAppStateTitle){
		return;
	}
	self.state = kAppStateGame;
}

- (void)hideGame{
	if(self.state != kAppStateGame){
		return;
	}
	self.state = kAppStateTitle;
}

// 広告表示関連
-(NSArray*)adKeyForAdMakerView:(AdMakerView*)view{
	return [NSArray arrayWithObjects:@"FIXME",@"FIXME",@"FIXME",nil];
}

-(UIViewController*)currentViewControllerForAdMakerView:(AdMakerView*)view{
	return self;
}

- (void)didLoadAdMakerView:(AdMakerView*)view{
	self.adMakerView.view.transform = CGAffineTransformMakeTranslation(0, self.gameViewController.adBaseView.frame.size.height);
	[self.gameViewController.view addSubview: self.adMakerView.view];
	[UIView animateWithDuration: 0.2
					 animations: ^{
						 self.adMakerView.view.transform = CGAffineTransformIdentity;
					 }
	 ];
}

- (void)didFailedLoadAdMakerView:(AdMakerView*)view{
	[UIView animateWithDuration: 0.2
					 animations: ^{
						 self.adMakerView.view.transform = CGAffineTransformMakeTranslation(0, self.gameViewController.adBaseView.frame.size.height);
					 }
					 completion: ^(BOOL finished){
						 [self.adMakerView.view removeFromSuperview];
					 }
	 ];
}


@end
