//
//  GlobalUtility.m
//  MasterMind
//
//  Created by minidam on 11/09/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GlobalUtility.h"
#import "Constants.h"
#import "UIBlockAlertView.h"


@implementation GlobalUtility

+ (BOOL)saveContext: (NSManagedObjectContext*)context{
	NSError* error = nil;
	if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		[self fatalError: [error localizedDescription]];
		return NO;
	}
	return YES;
}

+ (void)fatalError: (NSString*)message{
	[[UIBlockAlertView alertViewWithTitle: kAppTitle
								  message: [NSString stringWithFormat: @"致命的エラーです。アプリケーションを再起動してください。%@", message]
					 clickedButtonAtIndex: ^(UIBlockAlertView* alertView, NSInteger idx){
						 [alertView performSelector: @selector(show)
										 withObject: nil
										 afterDelay: 0.5
						  ];
					 }
						cancelButtonTitle: @"OK"
						 otherButtonTitle: nil
	  ] show];
}

+ (void)setElapsed: (NSInteger)elapsed
  minDigitalNumber: (DigitalNumber*)minDigitalNumber
  secDigitalNumber: (DigitalNumber*)secDigitalNumber
		  animated: (BOOL)animated{
	NSInteger min = 99;
	NSInteger sec = 99;
	// ms -> s
	elapsed = elapsed / 1000;
	
	if(elapsed < 100 * 60){
		min = elapsed / 60;
		sec = elapsed % 60;
	}
	
	if(animated){
		[minDigitalNumber setValue: min];
		[secDigitalNumber setValue: sec];
	}else{
		[minDigitalNumber setValueWithoutAnimation: min];
		[secDigitalNumber setValueWithoutAnimation: sec];
	}
}


@end
