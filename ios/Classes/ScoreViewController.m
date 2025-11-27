    //
//  ScoreViewController.m
//  MasterMind
//
//  Created by minidam on 11/09/10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScoreViewController.h"
#import "ScorePageController.h"
#import "Constants.h"
#import "NSTimer+Block.h"
#import "GlobalUtility.h"

@interface ScoreViewController ();

@property(retain) NSMutableArray* pageList;
@property(assign) enum ScrollContentState contentState;
@property(retain) NSMutableArray* ballNumList;
@property(assign) NSInteger curIndex;
@property(assign) BOOL scrolling;
@property(retain) NSTimer* repeatTimer;

-(void)buildScrollView;
-(void)initContent;
-(NSInteger)indexFromBalls: (NSInteger)balls;
-(void)updateContent;
-(ScorePageController*)pageAt: (NSInteger)page;

@end

@implementation ScoreViewController

@synthesize managedObjectContext=managedObjectContext_;
@synthesize preference=preference_;
@synthesize done=done_;
@synthesize scrollView=scrollView_;
@synthesize priorButton=priorButton_;
@synthesize nextButton=nextButton_;
@synthesize pageList=pageList_;
@synthesize contentState=contentState_;
@synthesize ballNumList=ballNumList_;
@synthesize curIndex=curIndex_;
@synthesize repeatTimer=repeatTimer_;
@synthesize scrolling=scrolling_;

- (id)init{
	if((self = [super init]) != nil){
		[[NSBundle mainBundle] loadNibNamed: @"ScoreViewController"
									  owner: self
									options: nil
		 ];
		self.pageList = [NSMutableArray arrayWithCapacity: 3];
	}
	return self;
}


- (void)dealloc{
	self.ballNumList = nil;
	self.pageList = nil;
	self.preference = nil;
	self.managedObjectContext = nil;
	self.done = nil;
	self.scrollView.delegate = nil;
	self.scrollView = nil;
	self.priorButton = nil;
	self.nextButton = nil;
	
	[super dealloc];
}

- (void)setRepeatTimer: (NSTimer*)timer{
	if(repeatTimer_ == timer){
		return;
	}
	[repeatTimer_ invalidate];
	[repeatTimer_ release];
	repeatTimer_ = timer;
	[repeatTimer_ retain];
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear: animated];
	[self initContent];
}

- (IBAction)onDonePressed: (id)sender{
	if(self.done != nil){
		(self.done)();
	}
}

-(ScorePageController*)pageAt: (NSInteger)page{
	return (ScorePageController*)[self.pageList objectAtIndex: page];
}

// 初回の表示
-(void)initContent{
	// データベースを最新の状態に同期する
	[GlobalUtility saveContext: self.managedObjectContext];
	[self buildScrollView];
	
	self.curIndex = [self indexFromBalls: self.preference.balls];
	[self updateContent];
}


// スクロールビューの初期化
-(void)buildScrollView{
	int width = self.scrollView.frame.size.width;
	int height = self.scrollView.frame.size.height;
	
	for(ScorePageController* page in self.pageList){
		[page.view removeFromSuperview];
	}
	[self.pageList removeAllObjects];
	
	for(int i = 0; i < 3; ++i){
		ScorePageController* page = [[[ScorePageController alloc] init] autorelease];
		page.managedObjectContext = self.managedObjectContext;
		page.view.frame = CGRectMake(
									 width * i,
									 0,
									 width,
									 height
									 );
		[self.scrollView addSubview: page.view];
		[self.pageList addObject: page];
	}
	
	// ボールの一覧の作成
	self.ballNumList = [NSMutableArray arrayWithCapacity: kBallsMax - kBallsMin + 1];
	for(NSInteger balls = kBallsMin; balls <= kBallsMax; ++balls){
		[self.ballNumList addObject: [NSNumber numberWithInteger: balls]];
	}
	
	self.curIndex = -1;
	self.contentState = kScrollContentStateNone;
}

-(NSInteger)indexFromBalls: (NSInteger)balls{
	return [self.ballNumList indexOfObjectPassingTest: ^(id obj, NSUInteger idx, BOOL *stop){
		return (BOOL)([obj integerValue] == balls);
	}];
}

-(void)updateContent{
	NSInteger pages = [self.ballNumList count];
	int width = self.scrollView.frame.size.width;
	int height = self.scrollView.frame.size.height;
	
	if(self.curIndex >= pages){
		// 無効
		self.contentState = kScrollContentStateNone;
	}else if(pages == 1){
		// ステージが１つしかない
		self.contentState = kScrollContentStateFirstAndLast;
	}else if(self.curIndex == 0){
		// 先頭
		self.contentState = kScrollContentStateFirst;
	}else if(self.curIndex == pages - 1){
		// 末尾
		self.contentState = kScrollContentStateLast;
	}else{
		self.contentState = kScrollContentStateMid;
	}
	
	[CATransaction begin];
	switch(self.contentState){
		case kScrollContentStateNone:
			[self pageAt: 0].balls = -1;
			[self pageAt: 1].balls = -1;
			[self pageAt: 2].balls = -1;
			self.scrollView.contentSize = CGSizeMake(width, height);
			self.scrollView.contentOffset = CGPointMake(0, 0);
			self.priorButton.enabled = NO;
			self.nextButton.enabled = NO;
			break;
		case kScrollContentStateFirstAndLast:
			[self pageAt: 0].balls = [[self.ballNumList objectAtIndex: self.curIndex] integerValue];
			[self pageAt: 1].balls = -1;
			[self pageAt: 2].balls = -1;
			self.scrollView.contentSize = CGSizeMake(width, height);
			self.scrollView.contentOffset = CGPointMake(0, 0);
			self.priorButton.enabled = NO;
			self.nextButton.enabled = NO;
			break;
		case kScrollContentStateFirst:
			[self pageAt: 0].balls = [[self.ballNumList objectAtIndex: self.curIndex] integerValue];
			[self pageAt: 1].balls = [[self.ballNumList objectAtIndex: self.curIndex + 1] integerValue];
			[self pageAt: 2].balls = -1;
			self.scrollView.contentSize = CGSizeMake(width * 2, height);
			self.scrollView.contentOffset = CGPointMake(0, 0);
			self.priorButton.enabled = NO;
			self.nextButton.enabled = YES;
			break;
		case kScrollContentStateLast:
			[self pageAt: 0].balls = [[self.ballNumList objectAtIndex: self.curIndex - 1] integerValue];
			[self pageAt: 1].balls = [[self.ballNumList objectAtIndex: self.curIndex] integerValue];
			[self pageAt: 2].balls = -1;
			self.scrollView.contentSize = CGSizeMake(width * 2, height);
			self.scrollView.contentOffset = CGPointMake(width, 0);
			self.priorButton.enabled = YES;
			self.nextButton.enabled = NO;
			break;
		default: //kScrollContentStateMid
			[self pageAt: 0].balls = [[self.ballNumList objectAtIndex: self.curIndex - 1] integerValue];
			[self pageAt: 1].balls = [[self.ballNumList objectAtIndex: self.curIndex] integerValue];
			[self pageAt: 2].balls = [[self.ballNumList objectAtIndex: self.curIndex + 1] integerValue];
			self.scrollView.contentSize = CGSizeMake(width * 3, height);
			self.scrollView.contentOffset = CGPointMake(width, 0);
			self.priorButton.enabled = YES;
			self.nextButton.enabled = YES;
			break;
	}
	[CATransaction commit];
}

// スクロールされた(ユーザの操作によるもの)
-(void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView{
	int width = self.scrollView.frame.size.width;
	CGFloat x = self.scrollView.contentOffset.x;
	self.scrolling = NO;
	
	switch(self.contentState){
		case kScrollContentStateNone:
			// 何もないんだから選択のしようがない
			return;
		case kScrollContentStateFirstAndLast:
			// １つしかないから変更のしようがない
			return;
		case kScrollContentStateFirst:
			// 次にしかいきようがない
			if(x < width){
				return;
			}
			self.curIndex += 1;
			[self updateContent];
			break;
		case kScrollContentStateLast:
			// 前にしかいきようがない
			if(width <= x){
				return;
			}
			self.curIndex -= 1;
			[self updateContent];
			break;
		default: //kScrollContentStateMid
			if(x < width){
				self.curIndex -= 1;
				[self updateContent];
			}else if(x < width * 2){
				return;
			}else{
				self.curIndex += 1;
				[self updateContent];
			}
			break;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	self.scrolling = YES;
}

// スクロールされた
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
	int width = self.scrollView.frame.size.width;
	int x = self.scrollView.contentOffset.x;
	
	if(x % width == 0){
		[self scrollViewDidEndDecelerating: self.scrollView];
	}
}

-(IBAction)goPriorUp: (id)sender{
	self.repeatTimer = nil;
}

-(IBAction)goPriorDown: (id)sender{
	[self goPrior];
	self.repeatTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5f
														 block: ^(NSTimer* timer){
															 [self goPrior];
														 }
													   repeats: YES
						];
}

// 前へ
-(void)goPrior{
	if(self.scrolling){
		return;
	}
	
	switch(self.contentState){
		case kScrollContentStateNone:
		case kScrollContentStateFirstAndLast:
		case kScrollContentStateFirst:
			break;
		case kScrollContentStateLast:
			[self.scrollView setContentOffset: CGPointMake(0, 0)
									 animated: YES
			 ];
			self.scrolling = YES;
			break;
		default: //kScrollContentStateMid
			[self.scrollView setContentOffset: CGPointMake(0, 0)
									 animated: YES
			 ];
			self.scrolling = YES;
			break;
	}
}

-(IBAction)goNextUp: (id)sender{
	self.repeatTimer = nil;
}

-(IBAction)goNextDown: (id)sender{
	[self goNext];
	
	self.repeatTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5f
														 block: ^(NSTimer* timer){
															 [self goNext];
														 }
													   repeats: YES
						];
}


// 次へ
-(void)goNext{
	if(self.scrolling){
		return;
	}
	int width = self.scrollView.frame.size.width;
	switch(self.contentState){
		case kScrollContentStateNone:
		case kScrollContentStateFirstAndLast:
		case kScrollContentStateLast:
			break;
		case kScrollContentStateFirst:
			[self.scrollView setContentOffset: CGPointMake(width, 0)
									 animated: YES
			 ];
			self.scrolling = YES;
			break;
		default: //kScrollContentStateMid
			[self.scrollView setContentOffset: CGPointMake(width * 2, 0)
									 animated: YES
			 ];
			self.scrolling = YES;
			break;
	}
}


@end
