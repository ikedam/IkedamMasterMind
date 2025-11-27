//
//  Preference.m
//  MasterMind
//
//  Created by minidam on 11/07/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Preference.h"
#import "Constants.h"

@interface Preference ()

- (void)loadDefaults;

@end

@implementation Preference

@synthesize balls=balls_;
@synthesize startAnimation=startAnimation_;
@synthesize backAnimation=backAnimation_;

+ (void)initialize{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
								 [NSNumber numberWithInteger: kDefaultBalls],          kDefaultKeyBalls,
								 [NSNumber numberWithBool:    kDefaultStartAnimation], kDefaultKeyStartAnimation,
								 [NSNumber numberWithBool:    kDefaultBackAnimation],  kDefaultKeyBackAnimation,
								 nil
								 ]
	 ];
								 
}

- (id)initFromDefaults{
	if((self = [self init]) != nil){
		[self loadDefaults];
	}
	return self;
}

- (void)loadDefaults{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	self.balls          = [defaults integerForKey: kDefaultKeyBalls];
	self.startAnimation = [defaults boolForKey:    kDefaultKeyStartAnimation];
	self.backAnimation  = [defaults boolForKey:    kDefaultKeyBackAnimation];
}

- (void)saveDefaults{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger: self.balls          forKey: kDefaultKeyBalls];
	[defaults setBool:    self.startAnimation forKey: kDefaultKeyStartAnimation];
	[defaults setBool:    self.backAnimation  forKey: kDefaultKeyBackAnimation];
}


@end
