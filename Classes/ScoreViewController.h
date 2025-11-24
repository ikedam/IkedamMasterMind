//
//  ScoreViewController.h
//  MasterMind
//
//  Created by minidam on 11/09/10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Preference.h"

enum ScrollContentState{
	kScrollContentStateNone,	// 内容なし
	kScrollContentStateFirstAndLast,	// １つだけ
	kScrollContentStateFirst, //先頭
	kScrollContentStateMid,	// 真ん中
	kScrollContentStateLast,	// 末尾
};


@interface ScoreViewController : UIViewController<UIScrollViewDelegate> {
@private
	void (^done_)(void);
	NSManagedObjectContext* managedObjectContext_;
	Preference* preference_;
	UIButton* priorButton_;
	UIButton* nextButton_;
	UIScrollView* scrollView_;
	
	NSMutableArray* pageList_;
	NSMutableArray* ballNumList_;
	NSInteger curIndex_;
	enum ScrollContentState contentState_;
	BOOL scrolling_;
	NSTimer* repeatTimer_;
}

@property(copy) void (^done)(void);
@property(retain) NSManagedObjectContext* managedObjectContext;
@property(retain) Preference* preference;
@property(retain) IBOutlet UIButton* priorButton;
@property(retain) IBOutlet UIButton* nextButton;
@property(retain) IBOutlet UIScrollView* scrollView;

- (IBAction)onDonePressed: (id)sender;
- (IBAction)goPriorDown: (id)sender;
- (IBAction)goPriorUp: (id)sender;
- (void)goPrior;
- (IBAction)goNextDown: (id)sender;
- (IBAction)goNextUp: (id)sender;
- (void)goNext;


@end
