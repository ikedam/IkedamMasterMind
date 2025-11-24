//
//  PreferenceController.m
//  MasterMind
//
//  Created by minidam on 11/07/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PreferenceController.h"

@interface PreferenceController ()

@property(retain) UINavigationController* navigationController;
@property(retain) PreferenceRootViewController* rootViewController;

@end


@implementation PreferenceController

@synthesize navigationController=navigationController_;
@synthesize rootViewController=rootViewController_;
@synthesize done=done_;

- (UIViewController*)viewController{
	return self.navigationController;
}

- (id)init{
	if((self = [super init]) != nil){
		/*
		 // この方法だと、実際にはビューがロードされていない場合がある。
		self.rootViewController = [[[PreferenceRootViewController alloc]
									initWithNibName: @"PreferenceRootViewController"
									bundle: [NSBundle mainBundle]
									] autorelease];
		 */
		self.rootViewController = [[[PreferenceRootViewController alloc]
									init
									] autorelease];
		self.rootViewController.done = ^(void){
			if(self.done != nil){
				(self.done)();
			}
		};
		self.navigationController = [[[UINavigationController alloc]
									  initWithRootViewController: self.rootViewController
									  ] autorelease];
	}
	return self;
}

- (void)dealloc{
	self.done = nil;
	self.navigationController = nil;
	self.rootViewController = nil;
	
	[super dealloc];
}

-(Preference*)preference{
	Preference* preference = [[[Preference alloc] init] autorelease];
	preference.balls = self.rootViewController.balls;
	preference.startAnimation = self.rootViewController.startAnimation;
	preference.backAnimation = self.rootViewController.backAnimation;
	return preference;
}

- (void)setPreference:(Preference*)preference{
	self.rootViewController.balls = preference.balls;
	self.rootViewController.startAnimation = preference.startAnimation;
	self.rootViewController.backAnimation = preference.backAnimation;
}



@end
