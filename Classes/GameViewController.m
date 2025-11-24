//
//  GameController.m
//  MasterMind
//
//  Created by minidam on 11/07/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "UIBlockAlertView.h"
#import "Constants.h"
#import "MasterMindAppDelegate.h"
#import "UIEventWindow.h"
#import "Ball.h"
#import "Hole.h"
#import "CALayer+Image.h"
#import "NSTimer+Block.h"
#import "GlobalUtility.h"
#import "TriedAnswer.h"

enum MatchResult{
	kMatchNot,
	kMatchHit,
	kMatchBlow,
};

@interface GameViewController ()

@property(assign) enum GameState state;
@property(assign) NSInteger holes;	// 穴の数
@property(assign) NSInteger balls;	// ゲームで使用するボールの数
@property(assign) NSInteger tries;	// 現在のターン
@property(retain) NSArray* answer;	// こたえ
@property(retain) NSMutableArray* lastAnswer;	// 前回の答え(同じ回答は続けて行えない)
@property(retain) NSArray* ballImageNameList;	// 玉の画像のリスト
@property(retain) NSMutableArray* ballList;	// 玉のリスト
@property(retain) NSMutableArray* holeList;	// 穴のリスト
@property(retain,readonly) CALayer* plateLayer;	// ユーザが玉を操作する範囲のレイヤー
@property(retain) Ball* draggingBall;	// ドラッグ中のボール
@property(assign) UITouch* draggingTouch;	// ドラッグに使用しているタッチ
@property(assign) CGPoint dragStartPoint;	// ドラッグの開始ポイント
@property(assign) CGPoint dragBallPosition;	// ドラッグ開始時のボールの場所
@property(retain) BallFitInfo* ballFitInfo;	// フィットしている先の情報
@property(retain) History* history;	// ヒストリ
@property(retain) CALayer* judgeMinidam; // ミニダムの画像
@property(retain) CALayer* judgeBaloon; // 吹き出し
@property(retain) CALayer* judgeShower;	//　花吹雪
@property(retain) NSMutableArray* flagLayerList;	// 旗の画像
@property(retain) Record* record;	// 現在のスコアレコード
@property(retain) BackAnimation* backAnimation;	// 背景アニメーション
@property(assign) BOOL isStartAnimation;	// 開始アニメーションを行うか？
@property(assign) BOOL isBackAnimation;		// 背景アニメーションを行うか？
@property(retain) DigitalNumber* timeMinNumber;	// 時間表時
@property(retain) DigitalNumber* timeSecNumber;	// 時間表時
@property(retain) CALayer* timeSeperator;	// 時間区切り
@property(retain) DigitalNumber* triesNumber;	// ターン数の表示

- (void)initGame;
- (BallFitInfo*)whereToFit:(CGPoint)point;
- (void)dragStartAt: (CGPoint)point ball: (Ball*)ball;
- (void)dragMoveTo: (CGPoint)point;
- (void)dragEndAt: (CGPoint)point;
- (void)resetHoles;
- (void)setInitBalls;
- (void)updateTryButton;
- (void)updateHistory;
- (BOOL)sameToLastAnswer;
- (enum MatchResult)findMatchBall: (NSInteger)ballIndex pos: (NSInteger)position;
- (void) doJudgeAnimation: (NSInteger)phase
					 hits: (NSInteger)hits
					blows: (NSInteger)blows;
- (void)updateRecord: (TriedAnswer*)triedAnswer;
- (void)openingDone;
- (void)willEnterBackground;

@end


@implementation GameViewController

@synthesize plateView=plateView_;
@synthesize menuView=menuView_;
@synthesize clearMenuView=clearMenuView_;
@synthesize adBaseView=adBaseView_;
@synthesize tryButton=tryButton_;
@synthesize historyImageView=historyImageView_;
@synthesize historyScrollView=historyScrollView_;
@synthesize judgeAnimationView=judgeAnimationView_;
@synthesize backAnimationView=backAnimationView_;
@synthesize menuPanelView=menuPanelView_;
@synthesize historyView=historyView_;
@synthesize upperBeltView=upperBeltView_;
@synthesize lowerBeltView=lowerBeltView_;
@synthesize backToTitle=backToTitle_;
@synthesize preference=preference_;
@synthesize state=state_;
@synthesize holes=holes_;
@synthesize balls=balls_;
@synthesize tries=tries_;
@synthesize answer=answer_;
@synthesize lastAnswer=lastAnswer_;
@synthesize ballImageNameList=ballImageNameList_;
@synthesize ballList=ballList_;
@synthesize holeList=holeList_;
@synthesize draggingBall=draggingBall_;
@synthesize draggingTouch=draggingTouch_;
@synthesize dragStartPoint=dragStartPoint_;
@synthesize dragBallPosition=dragBallPosition_;
@synthesize ballFitInfo=ballFitInfo_;
@synthesize history=history_;
@synthesize judgeMinidam=judgeMinidam_;
@synthesize judgeBaloon=judgeBaloon_;
@synthesize flagLayerList=flagLayerList_;
@synthesize judgeShower=judgeShower_;
@synthesize managedObjectContext=managedObjectContext_;
@synthesize record=record_;
@synthesize backAnimation=backAnimation_;
@synthesize isStartAnimation=isStartAnimation_;
@synthesize isBackAnimation=isBackAnimation_;
@synthesize timeMinNumber=timeMinNumber_;
@synthesize timeSecNumber=timeSecNumber_;
@synthesize timeSeperator=timeSeperator_;
@synthesize triesNumber=triesNumber_;

- (CALayer*)plateLayer{
	return self.plateView.layer;
}

- (void)setTries:(NSInteger)tries{
	tries_ = tries;
	//[self.triesNumber setValueWithoutAnimation: tries];
	self.triesNumber.value = tries;
}

- (id)init{
	if((self = [super init]) != nil){
		[[NSBundle mainBundle] loadNibNamed: @"GameViewController"
									  owner: self
									options: nil
		 ];
		self.holes = kHoles;
		self.balls = kDefaultBalls;
		self.ballImageNameList = [NSArray arrayWithObjects:
							  @"ball_red_large.png",
							  @"ball_blue_large.png",
							  @"ball_green_large.png",
							  @"ball_yellow_large.png",
							  @"ball_pink_large.png",
							  @"ball_purple_large.png",
							  @"ball_black_large.png",
							  @"ball_aqua_large.png",
							  nil
							  ];
		MasterMindAppDelegate* appDelegate = (MasterMindAppDelegate*)([UIApplication sharedApplication].delegate);
		appDelegate.willEnterBackground = ^(UIApplication* application){
			[self willEnterBackground];
		};
		UIEventWindow* window = appDelegate.window;
		window.touchesEventDelegate = self;
		
		// 穴の配置
		self.holeList = [NSMutableArray arrayWithCapacity: self.holes];
		for(NSInteger i = 0; i < self.holes; ++i){
			Hole* hole = [Hole holeWithIndex: i
									 centerX: kFirstHoleX + kHoleDistance * i
									 centerY: kHoleY
						  ];
			[self.holeList addObject: hole];
		}
		
		// 正解判定のミニダムの絵。
		// 中心点をいちばん上の真ん中にする
		self.judgeMinidam = [CALayer layerImageNamed: @"minidam_judge.png"];
		self.judgeMinidam.anchorPoint = CGPointMake(0.5, 0);
		self.judgeMinidam.position = CGPointMake(
												 self.judgeAnimationView.frame.size.width / 2,
												 self.judgeAnimationView.frame.size.height
												 );
		[self.judgeAnimationView.layer addSublayer: self.judgeMinidam];
		
		// 吹き出し
		self.judgeBaloon = [CALayer layerImageNamed: @"baloon.png"];
		self.judgeBaloon.hidden = YES;
		self.judgeBaloon.anchorPoint = CGPointMake(0.5, 0);
		self.judgeBaloon.position = CGPointMake(
												self.judgeAnimationView.frame.size.width / 2,
												14
												);
		[self.judgeAnimationView.layer addSublayer: self.judgeBaloon];
		
		// 花吹雪
		self.judgeShower = [CALayer layerImageNamed: @"shower.png"];
		self.judgeShower.anchorPoint = CGPointMake(0.5, 0);
		self.judgeShower.position = CGPointMake(
												self.judgeAnimationView.frame.size.width / 2,
												-self.judgeShower.frame.size.height
												);
		[self.judgeAnimationView.layer addSublayer: self.judgeShower];
		
		self.flagLayerList = [NSMutableArray arrayWithCapacity: 4];
		
		NSMutableArray* timeImageList = [NSMutableArray arrayWithCapacity: 0];
		for(NSInteger i = 0; i < 10; ++i){
			NSString* imageName = [NSString stringWithFormat: @"timer_num%d", i];
			[timeImageList addObject: [UIImage imageNamed: imageName]];
		}
		
		self.timeMinNumber = [[[DigitalNumber alloc] initWithImages: timeImageList
															  width: 18
															 height: 25
																gap: -1
															figures: 2
													   fillWithZero: YES
							   ] autorelease];
		
		self.timeSecNumber = [[[DigitalNumber alloc] initWithImages: timeImageList
															  width: 18
															 height: 25
																gap: -1
															figures: 2
													   fillWithZero: YES
							   ] autorelease];
		self.timeMinNumber.layer.position = CGPointMake(123, 7);
		[self.menuPanelView.layer addSublayer: self.timeMinNumber.layer];
		
		self.timeSecNumber.layer.position = CGPointMake(163, 7);
		[self.menuPanelView.layer addSublayer: self.timeSecNumber.layer];
		
		self.timeSeperator = [CALayer layerImageNamed: @"timer_sep.png"];
		self.timeSeperator.anchorPoint = CGPointMake(0, 0);
		self.timeSeperator.position = CGPointMake(157, 12);
		[self.menuPanelView.layer addSublayer: self.timeSeperator];
		
		// 100msごとに起動するタイマー
		[NSTimer scheduledTimerWithTimeInterval: 0.1
										  block: ^(NSTimer* timer){
											  [self tick];
										  }
										repeats: YES
		 ];
		
		
		self.backAnimation = [[[BackAnimation alloc] initWithLayer: self.backAnimationView.layer] autorelease];
		self.backAnimation.openingDone = ^{
			[self openingDone];
		};
		
		NSMutableArray* triesImageList = [NSMutableArray arrayWithCapacity: 0];
		for(NSInteger i = 0; i < 10; ++i){
			NSString* imageName = [NSString stringWithFormat: @"turn_num%d", i];
			[triesImageList addObject: [UIImage imageNamed: imageName]];
		}
		
		self.triesNumber = [[[DigitalNumber alloc] initWithImages: triesImageList
															width: 15
														   height: 22
															  gap: 0
														  figures: 3
													 fillWithZero: NO
							 ] autorelease];
		self.triesNumber.layer.position = CGPointMake(kTurnNumberX, kHoleY + kTurnNumberY);
		[self.plateView.layer addSublayer: self.triesNumber.layer];
	}
	return self;
}

- (void)dealloc{
	MasterMindAppDelegate* appDelegate = (MasterMindAppDelegate*)([UIApplication sharedApplication].delegate);
	UIEventWindow* window = appDelegate.window;
	window.touchesEventDelegate = self;
	appDelegate.willEnterBackground = nil;
	
	self.managedObjectContext = nil;
	self.record = nil;
	self.ballFitInfo = nil;
	self.draggingTouch = nil;
	self.draggingBall = nil;
	self.ballImageNameList = nil;
	self.ballList = nil;
	self.holeList = nil;
	self.lastAnswer = nil;
	self.answer = nil;
	self.historyScrollView.delegate = nil;
	self.historyScrollView = nil;
	self.historyImageView = nil;
	self.judgeAnimationView = nil;
	self.backAnimationView = nil;
	self.menuPanelView = nil;
	self.historyView = nil;
	self.upperBeltView = nil;
	self.lowerBeltView = nil;
	self.tryButton = nil;
	self.plateView = nil;
	self.menuView = nil;
	self.clearMenuView = nil;
	self.adBaseView = nil;
	self.backToTitle = nil;
	self.preference = nil;
	self.history = nil;
	self.judgeMinidam = nil;
	self.judgeBaloon = nil;
	self.judgeShower = nil;
	self.backAnimation = nil;
	self.timeSeperator = nil;
	self.timeMinNumber = nil;
	self.timeSecNumber = nil;
	self.triesNumber = nil;
	[super dealloc];
}

- (void)setPreference:(Preference *)preference{
	if(preference_ != preference){
		[preference_ release];
		preference_ = preference;
		[preference_ retain];
	}
	
	self.balls = preference.balls;
	self.isStartAnimation = preference.startAnimation;
	self.isBackAnimation = preference.backAnimation;
}

- (void)setBalls:(NSInteger)balls{
	if(balls_ == balls){
		return;
	}
	
	balls_ = balls;
	self.state = kGameStateInit;
}

- (void)setIsBackAnimation:(BOOL)isBackAnimation{
	if(isBackAnimation_ == isBackAnimation){
		return;
	}
	isBackAnimation_ = isBackAnimation;
	if(isBackAnimation){
		[self.backAnimation resume];
	}else{
		[self.backAnimation pause];
	}
}

- (void)setState:(enum GameState)newState{
	enum GameState oldState = self.state;
	
	// ゲーム開始アニメなしの判定
	if(newState == kGameStateStart && !self.isStartAnimation){
		newState = kGameStateGame;
	}
	
	if(oldState == newState){
		return;
	}
	state_ = newState;
	
	switch(newState){
		case kGameStateMenu:
			[self.backAnimation pause];
			self.menuView.hidden = NO;
			break;
		case kGameStateClearMenu:
			[self.backAnimation pause];
			self.clearMenuView.hidden = NO;
			break;
		case kGameStateStart:
			self.upperBeltView.frame = CGRectMake(
												  self.upperBeltView.frame.origin.x,
												  0,
												  self.upperBeltView.frame.size.width,
												  self.upperBeltView.frame.size.height
												  );
			self.lowerBeltView.frame = CGRectMake(
												  self.lowerBeltView.frame.origin.x,
												  self.view.frame.size.height - self.lowerBeltView.frame.size.height,
												  self.lowerBeltView.frame.size.width,
												  self.lowerBeltView.frame.size.height
												  );
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey: kCATransactionDisableActions];
			self.historyView.hidden = YES;
			[CATransaction commit];
			// 開始アニメーション再生
			[self.backAnimation startOpeningAnimation];
			break;
		case kGameStateGame:
			if(self.isBackAnimation){
				[self.backAnimation startGameAnimation];
			}else{
				[self.backAnimation pause];
			}
			break;
		case kGameStateTrying:
			if(self.isBackAnimation){
				[self.backAnimation resume];
			}
			break;
		default:
			[self.backAnimation pause];
			break;
	}
	
	switch(oldState){
		case kGameStateStart:
			self.historyView.alpha = 0;
			[UIView animateWithDuration: 0.5
							 animations: ^{
								 self.historyView.hidden = NO;
								 self.historyView.alpha = 1.0;
								 self.upperBeltView.frame = CGRectMake(
																	   self.upperBeltView.frame.origin.x,
																	   -self.upperBeltView.frame.size.height,
																	   self.upperBeltView.frame.size.width,
																	   self.upperBeltView.frame.size.height
																	   );
								 self.lowerBeltView.frame = CGRectMake(
																	   self.lowerBeltView.frame.origin.x,
																	   self.view.frame.size.height,
																	   self.lowerBeltView.frame.size.width,
																	   self.lowerBeltView.frame.size.height
																	   );
							 }
			 ];
			break;
		case kGameStateMenu:
			self.menuView.hidden = YES;
			break;
		case kGameStateClearMenu:
			self.clearMenuView.hidden = YES;
			break;
	}
}

- (void)resume{
	switch(self.state){
		case kGameStateInit:
			[self initGame];
			break;
		case kGameStateMenu:
			self.state = kGameStateGame;
			break;
		case kGameStateSuspend:
			self.state = kGameStateGame;
			break;
	}
}

- (void)suspend{
	if(self.state == kGameStateGame){
		self.state = kGameStateSuspend;
	}
}

- (void)reset{
	if(self.record.tries > 0){
		// 終わった扱いにする
		self.record.finished = YES;
	}else{
		// 1回も挑戦していない場合はデータ削除(なかったことにする)
		[self.record deleteObject];
	}
	self.record = nil;
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey: kDefaultKeyRecordId];
	[defaults synchronize];	
	self.state = kGameStateInit;
}

// 穴の位置の初期化
- (void)resetHoles{
	for(Hole* hole in self.holeList){
		[hole reset];
	}
}

// 玉の初期配置
- (void)setInitBalls{
	// 玉の配置
	for(Ball* ball in self.ballList){
		[ball.layer removeFromSuperlayer];
	}
	self.ballList = [NSMutableArray arrayWithCapacity: self.balls];
	if(self.balls <= 4){
		// 1段
		for(NSInteger i = 0; i < self.balls; ++i){
			Ball* ball = [Ball ballWithIndex: i
								  imageNamed: [self.ballImageNameList objectAtIndex: i]
									 centerX: k0RowFirstBallX + k0RowBallDistance * i
									 centerY: k0RowBallY
						  ];
			[self.ballList addObject: ball];
			[self.plateLayer addSublayer: ball.layer];
		}
	}else{
		// 2段
		for(NSInteger i = 0; i < 4; ++i){
			Ball* ball = [Ball ballWithIndex: i
								  imageNamed: [self.ballImageNameList objectAtIndex: i]
									 centerX: k1RowFirstBallX + k1RowBallDistance * i
									 centerY: k1RowBallY
						  ];
			[self.ballList addObject: ball];
			[self.plateLayer addSublayer: ball.layer];
		}
		for(NSInteger i = 4; i < self.balls; ++i){
			Ball* ball = [Ball ballWithIndex: i
								  imageNamed: [self.ballImageNameList objectAtIndex: i]
									 centerX: k2RowFirstBallX + k2RowBallDistance * (i - 4)
									 centerY: k2RowBallY
						  ];
			[self.ballList addObject: ball];
			[self.plateLayer addSublayer: ball.layer];
		}
	}
}

// ゲーム初期化
// 解答の作成
// 玉の配置
- (void)initGame{
	self.tries = 1;
	// 解答の作成
	// 0..balls-1の配列をランダムに並び替える。
	NSMutableArray* cands = [NSMutableArray arrayWithCapacity: self.balls];
	for(NSInteger i = 0; i < self.balls; ++i){
		[cands addObject: [NSNumber numberWithInteger: i]];
	}
	for(NSInteger swapFrom = 0; swapFrom < self.holes; ++swapFrom){
		double r = ((double)arc4random()) / ARC4RANDOM_SIZE;
		NSInteger swapTo = (NSInteger)(r * (self.balls - swapFrom)) + swapFrom;
		if(swapTo == swapFrom){
			continue;
		}
		[cands exchangeObjectAtIndex: swapFrom
				   withObjectAtIndex: swapTo
		 ];
	}
	
	[self resetHoles];
	
	self.answer = [cands subarrayWithRange: NSMakeRange(0, self.holes)];
	self.lastAnswer = nil;
	self.history = [[[History alloc] init] autorelease];
	self.history.digitalNumber = self.triesNumber;
	[self updateHistory];
	[self updateTryButton];
	
	[self setInitBalls];
	[self doJudgeAnimation: 0 hits: 0 blows: 0];
	
	// データベースの処理
	if(self.record != nil){
		NSLog(@"WARNING: record is still remained...remove");
		if(self.record.tries > 0){
			// 終わった扱いにする
			self.record.finished = YES;
		}else{
			// 1回も挑戦していない場合はデータ削除(なかったことにする)
			[self.record deleteObject];
		}
	}
	self.record = nil;
	[GlobalUtility setElapsed: 0
			 minDigitalNumber: self.timeMinNumber
			 secDigitalNumber: self.timeSecNumber
					 animated: NO
	 ];
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey: kCATransactionDisableActions];
	self.timeSeperator.hidden = NO;
	[CATransaction commit];
	
	// トライデータを初期化(削除)
	[TriedAnswer deleteAllObject: self.managedObjectContext];
	
	self.state = kGameStateStart;
}

- (void)openingDone{
	self.state = kGameStateGame;
}

// 保存データからゲームを復元
// 復元できたらYES。
- (BOOL)recoverGameState{
	NSURL* uri = [[NSUserDefaults standardUserDefaults] URLForKey: kDefaultKeyRecordId];
	if(uri == nil){
		return NO;
	}
	NSManagedObjectID* objectId = [[self.managedObjectContext persistentStoreCoordinator] managedObjectIDForURIRepresentation: uri];
	NSError* error = nil;
	Record* record = (Record*)[self.managedObjectContext existingObjectWithID: objectId error: &error];
	if(error != nil){
	//if(YES || error != nil){
		NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
		[defaults removeObjectForKey: kDefaultKeyRecordId];
		[defaults synchronize];	
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		[GlobalUtility fatalError: [error localizedDescription]];
		return NO;
	}
	if(record == nil){
		return NO;
	}
	
	// データベースの処理
	if(self.record != nil){
		NSLog(@"WARNING: record is still remained...remove");
		if(self.record.tries > 0){
			// 終わった扱いにする
			self.record.finished = YES;
		}else{
			// 1回も挑戦していない場合はデータ削除(なかったことにする)
			[self.record deleteObject];
		}
	}
	
	self.record = record;
	
	self.balls = self.record.balls;
	self.tries = self.record.tries + 1;
	
	self.answer = [self.record answerByArray];
	self.history = [[[History alloc] init] autorelease];
	self.history.digitalNumber = self.triesNumber;
	self.lastAnswer = nil;
	
	NSArray* triedAnswerList = [TriedAnswer fetchAll: self.managedObjectContext];
	NSArray* lastArray = nil;
	if(triedAnswerList != nil){
		for(TriedAnswer* triedAnswer in triedAnswerList){
			lastArray = [triedAnswer answerByArray];
			[self.history addHistory: lastArray
								hits: triedAnswer.hits
							   blows: triedAnswer.blows
			 ];
		}
	}
	if(lastArray != nil){
		self.lastAnswer = [NSMutableArray arrayWithCapacity: [lastArray count]];
		[self.lastAnswer addObjectsFromArray: lastArray];
	}
	
	[GlobalUtility setElapsed: self.record.elapsed
			 minDigitalNumber: self.timeMinNumber
			 secDigitalNumber: self.timeSecNumber
					 animated: NO
	 ];
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey: kCATransactionDisableActions];
	self.timeSeperator.hidden = NO;
	[CATransaction commit];
	
	[self updateHistory];
	[self updateTryButton];
	
	[self setInitBalls];
	[self doJudgeAnimation: 0 hits: 0 blows: 0];
	
	self.state = kGameStateGame;
	
	return YES;
}


// メニューの表示を「開始」にするべきか、「再開」にするべきか
- (BOOL)isSuspended{
	return (self.state == kGameStateGame || self.state == kGameStateSuspend)
		&& self.record != nil;	// 一手以上やっている場合のみ
}

// ボタン操作
- (IBAction)onMenuPressed: (id)sender{
	if(self.state != kGameStateGame){
		return;
	}
	[self suspend];
	self.state = kGameStateMenu;
}

- (IBAction)onRetryPressed: (id)sender{
	[[UIBlockAlertView alertViewWithTitle: kAppTitle
								  message: @"現在のゲームをあきらめて最初からやりなおします。よろしいですか？"
					 clickedButtonAtIndex: ^(UIBlockAlertView* alertView_, NSInteger index){
						 if(index == 1){
							 [self reset];
							 [self resume];
						 }
					 }
						cancelButtonTitle: @"キャンセル"
						 otherButtonTitle: @"OK"
	  ] show];
}

- (IBAction)onSuspendPressed: (id)sender{
	if(self.state != kGameStateMenu){
		return;
	}
	self.state = kGameStateSuspend;
	if(self.backToTitle != nil){
		(self.backToTitle)();
	}
}

- (IBAction)onCancelPressed: (id)sender{
	if(self.state != kGameStateMenu){
		return;
	}
	self.state = kGameStateGame;
	[self resume];
}

- (IBAction)onBackToTitlePressed: (id)sender{
	if(self.state != kGameStateClearMenu){
		return;
	}
	if(self.backToTitle != nil){
		(self.backToTitle)();
	}
	[self reset];
	[self resume];
}

- (IBAction)onNextGamePressed: (id)sender{
	if(self.state != kGameStateClearMenu){
		return;
	}
	[self reset];
	[self resume];
}


- (enum MatchResult)findMatchBall: (NSInteger)ballIndex pos: (NSInteger)position{
	NSNumber* hitTest = [self.answer objectAtIndex: position];
	if([hitTest integerValue] == ballIndex){
		return kMatchHit;
	}
	
	for(NSNumber* blowTest in self.answer){
		if([blowTest integerValue] == ballIndex){
			return kMatchBlow;
		}
	}
	
	return kMatchNot;
}

// 正解アニメーション
// 1. ミニダムが出てくる
// 2. 吹き出し表示
// 11-14. 旗表示
// 21. 表示(ポーズ)
// 22. 吹き出し消去
// 23. ミニダム戻る
// 24. ヒストリを更新
// 31. 花吹雪
-(void) doJudgeAnimation: (NSInteger)phase
					hits: (NSInteger)hits
				   blows: (NSInteger)blows{
	switch (phase) {
		case 0:
			// 初期化
			[CATransaction begin];
			[CATransaction setDisableActions: YES];
			self.judgeShower.position = CGPointMake(
													self.judgeAnimationView.frame.size.width / 2,
													-self.judgeShower.frame.size.height
													);
			self.judgeMinidam.position = CGPointMake(self.judgeMinidam.position.x,
													 self.judgeAnimationView.frame.size.height
													 );
			self.judgeBaloon.hidden = YES;
			for(CALayer* layer in self.flagLayerList){
				[layer removeFromSuperlayer];
			}
			[self.flagLayerList removeAllObjects];
			[CATransaction commit];
			break;
		case 1:
			// ミニダムが出てくる
			[CATransaction begin];
			[CATransaction setAnimationDuration: 0.1];
			[CATransaction setCompletionBlock:^(void) {
				[CATransaction setCompletionBlock:^(void) {
					[self doJudgeAnimation: 2
									  hits: hits
									 blows: blows
					 ];
				}];
			}];
			self.judgeMinidam.position = CGPointMake(self.judgeMinidam.position.x,
													 44
													 );
			[CATransaction commit];
			break;
		case 2:
			// 2. 吹き出し表示
			for(CALayer* layer in self.flagLayerList){
				[layer removeFromSuperlayer];
			}
			[self.flagLayerList removeAllObjects];
			[CATransaction begin];
			[CATransaction setAnimationDuration: 0.1];
			[CATransaction setCompletionBlock:^(void) {
				[CATransaction setCompletionBlock:^(void) {
					[self doJudgeAnimation: 11
									  hits: hits
									 blows: blows
					 ];
				}];
			}];
			self.judgeBaloon.hidden = NO;
			[CATransaction commit];
			break;
		case 11:
		case 12:
		case 13:
		case 14:
		case 15:
		{
			// 11-14. 旗表示
			// 表示する旗の判定
			NSInteger flag = phase - 11;
			if(flag < hits){
				CALayer* layer = [CALayer layerImageNamed: @"flag_black_large.png"];
				layer.position = CGPointMake(
											 kJudgeFirstFlagX + kJudgeFlagDistance * flag,
											 kJudgeFlagY
											 );
				[self.flagLayerList addObject: layer];
				[self.judgeBaloon addSublayer: layer];
				[NSTimer scheduledTimerWithTimeInterval: 0.25
												  block: ^(NSTimer* timer){
													  [self doJudgeAnimation: phase + 1
																		hits: hits
																	   blows: blows
													   ];
												  }
												repeats: NO
				 ];
			}else if(flag < hits + blows){
				CALayer* layer = [CALayer layerImageNamed: @"flag_white_large.png"];
				layer.position = CGPointMake(
											 kJudgeFirstFlagX + kJudgeFlagDistance * flag,
											 kJudgeFlagY
											 );
				[self.flagLayerList addObject: layer];
				[self.judgeBaloon addSublayer: layer];
				[NSTimer scheduledTimerWithTimeInterval: 0.25
												  block: ^(NSTimer* timer){
													  [self doJudgeAnimation: phase + 1
																		hits: hits
																	   blows: blows
													   ];
												  }
												repeats: NO
				 ];
			}else{
				[NSTimer scheduledTimerWithTimeInterval: 0.25
												  block: ^(NSTimer* timer){
													  [self doJudgeAnimation: 21
																		hits: hits
																	   blows: blows
													   ];
												  }
												repeats: NO
				 ];
			}
			break;
		}
		case 21:
			// 表示(ポーズ)
			[NSTimer scheduledTimerWithTimeInterval: 0.5
											  block: ^(NSTimer* timer){
												  [self doJudgeAnimation: phase + 1
																	hits: hits
																   blows: blows
												   ];
											  }
											repeats: NO
			 ];
			break;
		case 22:
			// 22. 吹き出し消去
			[CATransaction begin];
			[CATransaction setAnimationDuration: 0.1];
			[CATransaction setCompletionBlock:^(void) {
				[CATransaction setCompletionBlock:^(void) {
					if(hits < self.holes){
						[self doJudgeAnimation: phase + 1
										  hits: hits
										 blows: blows
						 ];
					}else{
						// 正解
						[self doJudgeAnimation: 31
										  hits: hits
										 blows: blows
						 ];
					}
				}];
			}];
			self.judgeBaloon.hidden = YES;
			[CATransaction commit];
			break;
		case 23:
			// 23. ミニダム戻る
			[CATransaction begin];
			[CATransaction setAnimationDuration: 0.1];
			[CATransaction setCompletionBlock:^(void) {
				[CATransaction setCompletionBlock:^(void) {
					[self doJudgeAnimation: phase + 1
									  hits: hits
									 blows: blows
					 ];
				}];
			}];
			self.judgeMinidam.position = CGPointMake(self.judgeMinidam.position.x,
													 self.judgeAnimationView.frame.size.height
													 );
			[CATransaction commit];
			break;
		case 24:
		{
			// 24. ヒストリを更新
			[self updateHistory];
			self.tries++;
			// データベースに回答を追加/スコアを更新
			TriedAnswer* triedAnswer = [TriedAnswer insertNewObject: self.managedObjectContext];
			triedAnswer.turn = self.tries;
			triedAnswer.hits = hits;
			triedAnswer.blows = blows;
			[triedAnswer setAnswerByArray: self.lastAnswer];
			
			[self updateRecord: triedAnswer];
			
			self.state = kGameStateGame;
			break;
		}
		case 31:
			// 31. 花吹雪
			[CATransaction begin];
			[CATransaction setAnimationDuration: 3.0];
			[CATransaction setAnimationTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear]];
			[CATransaction setCompletionBlock:^(void) {
				[CATransaction setCompletionBlock:^(void) {
					[self doJudgeAnimation: phase + 1
									  hits: hits
									 blows: blows
					 ];
				}];
			}];
			self.judgeShower.position = CGPointMake(
													self.judgeShower.position.x,
													self.judgeAnimationView.frame.size.height
													);
			[CATransaction commit];
			break;
		case 32:
		{
			// クリア処理
			// データベースに回答を追加/スコアを更新
			TriedAnswer* triedAnswer = [TriedAnswer insertNewObject: self.managedObjectContext];
			triedAnswer.turn = self.tries;
			triedAnswer.hits = hits;
			triedAnswer.blows = blows;
			[triedAnswer setAnswerByArray: self.lastAnswer];
			
			[self updateRecord: triedAnswer];
			self.record.finished = YES;
			self.record.success = YES;
			self.record = nil;
			NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
			[defaults removeObjectForKey: kDefaultKeyRecordId];
			[defaults synchronize];
			
			self.state = kGameStateClearMenu;
			break;
		}
		default:
			break;
	}
}

- (void)updateRecord: (TriedAnswer*)triedAnswer{
	if(self.record == nil){
		// 一手目
		self.record = [Record insertNewObject: self.managedObjectContext];
		[self.record setAnswerByArray: self.answer];
		self.record.balls = self.balls;
		self.record.elapsed = 0;
		self.record.finished = NO;
		self.record.recordAt = [NSDate date];
		self.record.success = NO;
		self.record.tries = 1;
		self.record.uniqueTries = 1;
		
		if(![GlobalUtility saveContext: self.managedObjectContext]){
			return;
		}
		// ユニークキーを保存
		NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
		[defaults setURL: [[self.record objectID] URIRepresentation]
				  forKey: kDefaultKeyRecordId
		 ];
		[defaults synchronize];
	}else{
		self.record.tries += 1;
		if(![triedAnswer isDuplicate]){
			self.record.uniqueTries += 1;
		}
	}
	NSLog(@"record: tries=%d, uniqueTries=%d, elapsed=%d", self.record.tries, self.record.uniqueTries, self.record.elapsed / 1000);
	
	return;
}

- (IBAction)onTryPressed: (id)sender{
	self.state = kGameStateTrying;
	
	NSInteger hits = 0;
	NSInteger blows = 0;
	// 回答の作成
	// 正解との比較
	self.lastAnswer = [NSMutableArray arrayWithCapacity: self.holes];
	for(NSInteger i = 0; i < [self.holeList count]; ++i){
		Hole* hole = [self.holeList objectAtIndex: i];
		[self.lastAnswer addObject: [NSNumber numberWithInteger: hole.ballIndex]];
		enum MatchResult result = [self findMatchBall: hole.ballIndex pos: i];
		switch(result){
			case kMatchHit: // 位置、色正解
				++hits;
				break;
			case kMatchBlow: // 色正解
				++blows;
				break;
		}
	}
	[self.history addHistory: self.lastAnswer hits: hits blows: blows];
	[self updateTryButton];
	
	// 正解アニメーション
	// 1. ミニダムが出てくる
	// 2. 吹き出し表示
	// 3. 旗表示
	// 4. 吹き出し消去
	// 5. ミニダム戻る
	// 6. ヒストリを更新
	[self doJudgeAnimation: 1
					  hits: hits
					 blows: blows
	 ];	
}

- (BOOL)sameToLastAnswer{
	if(self.lastAnswer == nil){
		return NO;
	}
	for(NSInteger i = 0; i < [self.lastAnswer count]; ++i){
		Hole* hole = [self.holeList objectAtIndex: i];
		NSNumber* number = [self.lastAnswer objectAtIndex: i];
		if(hole.ballIndex != [number integerValue]){
			return NO;
		}
	}
	return YES;
}

- (void)updateTryButton{
	for(Hole* hole in self.holeList){
		if(hole.ballIndex < 0){
			self.tryButton.enabled = NO;
			return;
		}
	}
	// 前回の回答と同じじゃないか？
	if([self sameToLastAnswer]){
		self.tryButton.enabled = NO;
		return;
	}
	self.tryButton.enabled = YES;
}

- (void)updateHistory{
	UIImage* image = [self.history getHistoryImage];
	if(image == nil){
		// 何もない
		self.historyImageView.image = nil;
		self.historyScrollView.scrollEnabled = NO;
		// ビューの下にはみ出ている位置に表示する
		self.historyImageView.frame = CGRectMake(
												 0,
												 self.historyScrollView.frame.size.height,
												 self.historyScrollView.frame.size.width,
												 1
												 );
	}else if(image.size.height <= self.historyScrollView.frame.size.height){
		// スクロール内に収まる
		self.historyImageView.image = image;
		self.historyImageView.frame = CGRectMake(0,
												 self.historyImageView.frame.origin.y,
												 image.size.width,
												 image.size.height
												 );
		self.historyScrollView.contentSize = image.size;
		self.historyScrollView.scrollEnabled = NO;
		// 見える位置へスクロール
		[UIView animateWithDuration: 0.1f
						 animations: ^{
							 CGFloat y = self.historyScrollView.frame.size.height - image.size.height;
							 self.historyImageView.frame = CGRectMake(0,
																	  y,
																	  image.size.width,
																	  image.size.height
																	  );
						 }
		 ];
	}else{
		// スクロール内に収まらない
		self.historyImageView.image = image;
		self.historyImageView.frame = CGRectMake(0,
												 0,
												 image.size.width,
												 image.size.height
												 );
		self.historyScrollView.contentSize = image.size;
		self.historyScrollView.scrollEnabled = YES;
		[self.historyScrollView setContentOffset: CGPointMake(0,
															  image.size.height - self.historyScrollView.frame.size.height
															  )
										animated: YES
		 ];
	}
}

// ドラッグ系の処理
- (BallFitInfo*)whereToFit: (CGPoint)point{
	// 自分自身にフィット？
	if(CGRectContainsPoint(self.draggingBall.initFitRect, point)){
		return [BallFitInfo fitToSelf];
	}
	
	// 穴にフィット？
	for(Hole* hole in self.holeList){
		if(hole.ballIndex >= 0 && hole.ballIndex != self.draggingBall.index){
			// 他の玉が入っている
			continue;
		}
		if(CGRectContainsPoint(hole.fitRect, point)){
			return [BallFitInfo fitToHole: hole.index];
		}
	}
	
	return [BallFitInfo fitToNone];
	
}

- (void)dragStartAt: (CGPoint)point ball: (Ball*)ball{
	self.draggingBall = ball;
	// いちばん上に持ってくる
	[CATransaction begin];
	[CATransaction setDisableActions: YES];
	CALayer* parentLayer = self.draggingBall.layer.superlayer;
	[self.draggingBall.layer removeFromSuperlayer];
	[parentLayer addSublayer: self.draggingBall.layer];
	[CATransaction commit];
	
	if(self.draggingBall.holeIndex >= 0){
		self.ballFitInfo = [BallFitInfo fitToHole: self.draggingBall.holeIndex];
	}else{
		self.ballFitInfo = [BallFitInfo fitToSelf];
	}
	self.dragStartPoint = point;
	self.dragBallPosition = self.draggingBall.position;
	//NSLog(@"drag began: index=%d", self.draggingBall.index);
}

- (void)dragMoveTo: (CGPoint)point{
	// 単純にドラッグ状況に合わせて出てくる移動先のポイント
	CGPoint moveToPoint = CGPointMake(
									  self.dragBallPosition.x - self.dragStartPoint.x + point.x,
									  self.dragBallPosition.y - self.dragStartPoint.y + point.y
									  );
	
	// フィット位置を探す
	BallFitInfo* fitInfo = [self whereToFit: moveToPoint];
	switch(fitInfo.state){
		case kBallFitToSelf:
			moveToPoint = self.draggingBall.initPosition;
			break;
		case kBallFitToHole:
		{
			Hole* hole = [self.holeList objectAtIndex: fitInfo.holeIndex];
			moveToPoint = hole.position;
			break;
		}
	}
	
	if(![self.ballFitInfo isEqual: fitInfo]){
		self.ballFitInfo = fitInfo;
	}
	
	[CATransaction begin];
	[CATransaction setDisableActions: YES];
	self.draggingBall.position = moveToPoint;
	[CATransaction commit];
}

- (void)dragEndAt: (CGPoint)point{
	/*
	// 指を離すときのブレのせいでうまく動かないことがあるので、指の位置は見ない。
	// 単純にドラッグ状況に合わせて出てくる移動先のポイント
	CGPoint moveToPoint = CGPointMake(
									  self.dragBallPosition.x - self.dragStartPoint.x + point.x,
									  self.dragBallPosition.y - self.dragStartPoint.y + point.y
									  );
	*/
	CGPoint moveToPoint = self.draggingBall.position;
	
	// 元の設置位置を解放
	if(self.draggingBall.holeIndex >= 0){
		Hole* hole = [self.holeList objectAtIndex: self.draggingBall.holeIndex];
		hole.ballIndex = -1;
		self.draggingBall.holeIndex = -1;
	}
	
	// フィット位置を探す
	BallFitInfo* fitInfo = [self whereToFit: moveToPoint];
	switch(fitInfo.state){
		case kBallFitToSelf:
		case kBallFitToNone:
			moveToPoint = self.draggingBall.initPosition;
			break;
		case kBallFitToHole:
		{
			// 穴を占拠
			Hole* hole = [self.holeList objectAtIndex: fitInfo.holeIndex];
			moveToPoint = hole.position;
			hole.ballIndex = self.draggingBall.index;
			self.draggingBall.holeIndex = hole.index;
			break;
		}
	}
	
	if(![self.ballFitInfo isEqual: fitInfo]){
		self.ballFitInfo = fitInfo;
	}
	
	if(fitInfo.state != kBallFitToNone){
		[CATransaction begin];
		[CATransaction setDisableActions: YES];
		self.draggingBall.position = moveToPoint;
		[CATransaction commit];
	}else{
		[CATransaction begin];
		self.draggingBall.position = moveToPoint;
		[CATransaction commit];
	}
	[self updateTryButton];
	self.draggingBall = nil;
}

// タッチ時の処理
- (void)window:(UIWindow*)window touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if(self.state == kGameStateStart){
		self.state = kGameStateGame;
		return;
	}
	if(self.state != kGameStateGame){
		return;
	}
	if(self.draggingTouch != nil){
		// 既にドラッグ中なので無視
		return;
	}
	
	UITouch* touch = [touches anyObject];
	CGPoint pt = [touch locationInView: self.plateView];
	// どれかの玉をタップしているかのチェック
	for(Ball* ball in self.ballList){
		if(CGRectContainsPoint(ball.touchRect, pt)){
			self.draggingTouch = touch;
			[self dragStartAt: pt ball: ball];
			break;
		}
	}
}

- (void)window:(UIWindow*)window touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	if(self.state != kGameStateGame){
		return;
	}
	if(self.draggingTouch == nil){
		// ドラッグしてないので無視
		return;
	}
	
	UITouch* touch = [touches member: self.draggingTouch];
	if(touch == nil){
		NSLog(@"WARNING: touch not found!");
		[self dragEndAt: self.draggingBall.layer.position];
		self.draggingTouch = nil;
		return;
	}
	
	CGPoint pt = [touch locationInView: self.plateView];
	[self dragEndAt: pt];
	self.draggingTouch = nil;
}

- (void)window:(UIWindow*)window touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if(self.state != kGameStateGame){
		return;
	}
	if(self.draggingTouch == nil){
		// ドラッグしてないので無視
		return;
	}
	
	UITouch* touch = [touches member: self.draggingTouch];
	if(touch == nil){
		NSLog(@"WARNING: touch not found!");
		[self dragEndAt: self.draggingBall.layer.position];
		self.draggingTouch = nil;
		return;
	}
	
	CGPoint pt = [touch locationInView: self.plateView];
	[self dragEndAt: pt];
	self.draggingTouch = nil;
}

- (void)window:(UIWindow*)window touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if(self.state != kGameStateGame){
		return;
	}
	if(self.draggingTouch == nil){
		// ドラッグしてないので無視
		return;
	}

	UITouch* touch = [touches member: self.draggingTouch];
	if(touch == nil){
		NSLog(@"WARNING: touch not found!");
		[self dragEndAt: self.draggingBall.layer.position];
		self.draggingTouch = nil;
		return;
	}
	
	CGPoint pt = [touch locationInView: self.plateView];
	[self dragMoveTo: pt];
}

// 時間が経過した
// 100msごとに呼び出す
-(void)tick{
	if(self.state != kGameStateGame){
		// タイマーが進むのはゲーム中のみ
		return;
	}
	if(self.record == nil){
		return;
	}
	self.record.elapsed += 100;
	
	[GlobalUtility setElapsed: self.record.elapsed
			 minDigitalNumber: self.timeMinNumber
			 secDigitalNumber: self.timeSecNumber
					 animated: NO
	 ];
	if(self.record.elapsed % 1000 == 0){
		[CATransaction begin];
		[CATransaction setValue:(id)kCFBooleanTrue forKey: kCATransactionDisableActions];
		self.timeSeperator.hidden = !self.timeSeperator.hidden;
		[CATransaction commit];
	}
}

- (void)willEnterBackground{
	// ゲーム中であればメニューを開く
	if(self.state != kGameStateGame){
		return;
	}
	[self suspend];
	self.state = kGameStateMenu;
}

@end
