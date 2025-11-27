//
//  PreferenceController.h
//  MasterMind
//
//  Created by minidam on 11/07/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Preference.h"
#import "PreferenceRootViewController.h"


@interface PreferenceController : NSObject{
@private
	UINavigationController* navigationController_;
	PreferenceRootViewController* rootViewController_;
	void (^done_)(void);
}

@property(assign) Preference* preference;
@property(copy) void (^done)(void);
@property(retain,readonly) UIViewController* viewController;

@end
