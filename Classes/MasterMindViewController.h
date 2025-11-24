//
//  MasterMindViewController.h
//  MasterMind
//
//  Created by minidam on 11/06/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "HowtoViewController.h"
#import "Preference.h"
#import "GameViewController.h"
#import "AdMakerView.h"
#import "AdMakerDelegate.h"
#import "PreferenceController.h"
#import "ScoreViewController.h"

// アプリケーションの状態
enum AppState{
	kAppStateUnknown,	// 初期状態
	kAppStateInitGame,	// 最初からゲーム画面
	kAppStateTitle,	// タイトル画面
	kAppStateGame,	// ゲーム画面
	kAppStateScoreShowing,	// スコア画面表示中
	kAppStateScore,	// スコア画面
	kAppStateScoreHiding,	// スコア画面閉鎖中
	kAppStateConfig,	//　設定画面
	kAppStateHowtoShowing,	// 説明画面表示中
	kAppStateHowto,	// 説明画面
	kAppStateHowtoHiding,	// 説明画面閉鎖中
	kAppStatePreferenceShowing,	// 設定画面表示中
	kAppStatePreference,	// 設定画面
	kAppStatePreferenceHiding,	// 設定画面閉鎖中
};

@interface MasterMindViewController : UIViewController<AdMakerDelegate> {
@private
	NSManagedObjectContext* managedObjectContext_;
	HowtoViewController* howtoViewController_;
	ScoreViewController* scoreViewController_;
	GameViewController* gameViewController_;
	PreferenceController* preferenceController_;
	Preference* preference_;
	AdMakerView* adMakerView_;
	UIButton* startButton_;
	UIButton* restartButton_;
	enum AppState state_;	
}

@property(retain) IBOutlet UIButton* startButton;
@property(retain) IBOutlet UIButton* restartButton;

-(IBAction)onGamePressed: (id)sender;
-(IBAction)onScorePressed: (id)sender;
-(IBAction)onHowtoPressed: (id)sender;
-(IBAction)onPreferencePressed: (id)sender;
	
@end
