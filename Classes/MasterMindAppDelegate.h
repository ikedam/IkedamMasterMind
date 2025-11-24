//
//  MasterMindAppDelegate.h
//  MasterMind
//
//  Created by minidam on 11/06/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "UIEventWindow.h"
#import "MasterMindViewController.h"


@interface MasterMindAppDelegate : NSObject <UIApplicationDelegate> {
    UIEventWindow *window;
	IBOutlet MasterMindViewController* viewController_;
    
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
	void (^willEnterBackground_)(UIApplication*);
}

@property (nonatomic, retain) IBOutlet UIEventWindow *window;
@property (nonatomic, retain) MasterMindViewController* viewController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (copy) void (^willEnterBackground)(UIApplication*);

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

@end

