//
//  ScorePageController.h
//  MasterMind
//
//  Created by minidam on 11/09/10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DigitalNumber.h"


@interface ScorePageController : NSObject {
@private
	UIView* view_;
	NSManagedObjectContext* managedObjectContext_;
	NSInteger balls_;
	
	DigitalNumber* ballNumber_;
	DigitalNumber* gameNumber_;
	DigitalNumber* winNumber_;
	DigitalNumber* winRateIntNumber_;
	DigitalNumber* winRateFracNumber_;
	DigitalNumber* triesAvgIntNumber_;
	DigitalNumber* triesAvgFracNumber_;
	DigitalNumber* triesMaxNumber_;
	DigitalNumber* triesMinNumber_;
	DigitalNumber* elapsedAvgMinNumber_;
	DigitalNumber* elapsedAvgSecNumber_;
	DigitalNumber* elapsedMaxMinNumber_;
	DigitalNumber* elapsedMaxSecNumber_;
	DigitalNumber* elapsedMinMinNumber_;
	DigitalNumber* elapsedMinSecNumber_;
	
	NSInteger games_;
	NSInteger wins_;
	float triesAvg_;
	NSInteger triesMax_;
	NSInteger triesMin_;
	NSInteger elapsedAvg_;
	NSInteger elapsedMax_;
	NSInteger elapsedMin_;
}

@property(retain) IBOutlet UIView* view;
@property(retain) NSManagedObjectContext* managedObjectContext;
@property(assign) NSInteger balls;

@end
