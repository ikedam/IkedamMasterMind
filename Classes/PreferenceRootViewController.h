//
//  PreferenceRootViewController.h
//  MasterMind
//
//  Created by minidam on 11/07/25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCellGroup.h"
#import "TableViewCell.h"
#import "PreferenceBallsViewController.h"

enum PreferenceState{
	kPreferenceStateRoot,
	kPreferenceStateBallsShowing,
	kPreferenceStateBalls,
};

@interface PreferenceRootViewController : UITableViewController{
@private
	enum PreferenceState state_;
	UITableViewCell* ballsCell_;
	UILabel* ballsLabel_;
	UIBarButtonItem* doneButton_;
	NSInteger balls_;
	PreferenceBallsViewController* ballsViewController_;
	
	UISwitch* startAnimationSwitch_;
	UISwitch* backAnimationSwitch_;
	
	UITableViewCell* gotoSiteCell_;
	UITableViewCell* gotoTravelCell_;
	UITableViewCell* startAnimationCell_;
	UITableViewCell* backAnimationCell_;
	
	UIView* versionView_;
	UILabel* versionLabel_;
	
	NSArray* cellGroupList_;
	void (^done_)(void);
}

@property(assign) NSInteger balls;
@property(assign) BOOL startAnimation;
@property(assign) BOOL backAnimation;
@property(retain) IBOutlet UITableViewCell* ballsCell;
@property(retain) IBOutlet UILabel* ballsLabel;
@property(retain) IBOutlet UIBarButtonItem* doneButton;
@property(retain) IBOutlet PreferenceBallsViewController* ballsViewController;
@property(retain) IBOutlet UISwitch* startAnimationSwitch;
@property(retain) IBOutlet UISwitch* backAnimationSwitch;
@property(retain) IBOutlet UITableViewCell* gotoSiteCell;
@property(retain) IBOutlet UITableViewCell* gotoTravelCell;
@property(retain) IBOutlet UITableViewCell* startAnimationCell;
@property(retain) IBOutlet UITableViewCell* backAnimationCell;
@property(retain) IBOutlet UIView* versionView;
@property(retain) IBOutlet UILabel* versionLabel;

@property(copy) void (^done)(void);

-(IBAction)donePressed: (id)sender;

@end
