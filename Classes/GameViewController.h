//
//  GameController.h
//  MasterMind
//
//  Created by minidam on 11/07/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>
#import "Ball.h"
#import "BallFitInfo.h"
#import "Preference.h"
#import "UIWindowTouchesEventDelegate.h"
#import "History.h"
#import "Record.h"
#import "BackAnimation.h"
#import "DigitalNumber.h"

enum GameState{
	kGameStateInit,	// 初期状態。
	kGameStateStart,	// 最初のアニメーション
	kGameStateGame,	// ゲーム中。ユーザ入力可能。
	kGameStateSuspend,	// サスペンド状態。
	kGameStateTrying,	// チェックアニメーション
	kGameStateClear,	// クリアアニメーション
	kGameStateMenu,	// メニュー
	kGameStateClearMenu,	// クリアメニュー
};

@interface GameViewController : UIViewController<UIWindowTouchesEventDelegate, UIScrollViewDelegate> {
@private
	UIView* plateView_;
	UIView* menuView_;
	UIView* adBaseView_;
	UIImageView* historyImageView_;
	UIScrollView* historyScrollView_;
	UIView* judgeAnimationView_;
	UIButton* tryButton_;
	void (^backToTitle)(void);
	UIView* clearMenuView_;
	UIView* backAnimationView_;
	UIView* menuPanelView_;
	UIView* historyView_;
	UIView* upperBeltView_;
	UIView* lowerBeltView_;
	
	Preference* preference_;
	
	enum GameState state_;
	NSInteger holes_;
	NSInteger balls_;
	NSInteger tries_;
	NSArray* answer_;
	NSArray* ballImageNameList_;
	NSMutableArray* ballList_;
	NSMutableArray* holeList_;
	NSMutableArray* lastAnswer_;
	NSMutableArray* flagLayerList_;
	
	Ball* draggingBall_;
	UITouch* draggingTouch_;
	CGPoint dragStartPoint_;
	CGPoint dragBallPosition_;
	BallFitInfo* ballFitInfo_;
	
	History* history_;
	
	CALayer* judgeMinidam_;
	CALayer* judgeBaloon_;
	CALayer* judgeShower_;
	
	NSManagedObjectContext* managedObjectContext_;
	Record* record_;
	
	BackAnimation* backAnimation_;
	BOOL isStartAnimation_;
	BOOL isBackAnimation_;
	
	DigitalNumber* timeMinNumber_;
	DigitalNumber* timeSecNumber_;
	CALayer* timeSeperator_;
	
	DigitalNumber* triesNumber_;
}

@property(retain) IBOutlet UIView* plateView;
@property(retain) IBOutlet UIView* menuView;
@property(retain) IBOutlet UIView* clearMenuView;
@property(retain) IBOutlet UIView* adBaseView;
@property(retain) IBOutlet UIButton* tryButton;
@property(retain) IBOutlet UIImageView* historyImageView;
@property(retain) IBOutlet UIScrollView* historyScrollView;
@property(retain) IBOutlet UIView* judgeAnimationView;
@property(retain) IBOutlet UIView* backAnimationView;
@property(retain) IBOutlet UIView* menuPanelView;
@property(retain) IBOutlet UIView* historyView;
@property(retain) IBOutlet UIView* upperBeltView;
@property(retain) IBOutlet UIView* lowerBeltView;
@property(copy) void (^backToTitle)(void);
@property(retain) Preference* preference;
@property(retain) NSManagedObjectContext* managedObjectContext;

- (void)tick;
- (void)reset;
- (void)resume;
- (void)suspend;
- (BOOL)recoverGameState;
- (BOOL)isSuspended;
- (IBAction)onMenuPressed: (id)sender;
- (IBAction)onRetryPressed: (id)sender;
- (IBAction)onSuspendPressed: (id)sender;
- (IBAction)onCancelPressed: (id)sender;
- (IBAction)onTryPressed: (id)sender;
- (IBAction)onBackToTitlePressed: (id)sender;
- (IBAction)onNextGamePressed: (id)sender;

@end
