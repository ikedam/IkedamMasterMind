//
//  History.h
//  MasterMind
//
//  Created by minidam on 11/07/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DigitalNumber.h"


@interface History : NSObject {
@private
	NSMutableArray* historyList_;
	NSArray* ballImageNameList_;
	NSMutableArray* ballImageList_;
	UIImage* hitFlagImage_;
	UIImage* blowFlagImage_;
	UILabel* referenceLabel_;
	DigitalNumber* digitalNumber_;
}

@property(retain) UILabel* referenceLabel;
@property(retain) DigitalNumber* digitalNumber;

- (void)addHistory: (NSArray*)answer hits: (NSInteger)hits blows: (NSInteger)blows;
- (UIImage*)getHistoryImage;

@end
