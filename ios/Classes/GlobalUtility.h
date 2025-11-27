//
//  GlobalUtility.h
//  MasterMind
//
//  Created by minidam on 11/09/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DigitalNumber.h"


@interface GlobalUtility : NSObject {

}

+ (BOOL)saveContext: (NSManagedObjectContext*)context;
+ (void)fatalError: (NSString*)message;
+ (void)setElapsed: (NSInteger)elapsed
  minDigitalNumber: (DigitalNumber*)minDigitalNumber
  secDigitalNumber: (DigitalNumber*)secDigitalNumber
		  animated: (BOOL)animated;

@end
