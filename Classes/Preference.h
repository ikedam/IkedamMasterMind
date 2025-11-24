//
//  Preference.h
//  MasterMind
//
//  Created by minidam on 11/07/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Preference : NSObject {
@private
	NSInteger balls_;
	BOOL startAnimation_;
	BOOL backAnimation_;
}

@property(assign) NSInteger balls;
@property(assign) BOOL startAnimation;
@property(assign) BOOL backAnimation;

- (id)initFromDefaults;
- (void)saveDefaults;

@end
