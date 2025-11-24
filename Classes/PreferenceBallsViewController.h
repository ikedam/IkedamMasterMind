//
//  PreferenceBallsViewController.h
//  MasterMind
//
//  Created by minidam on 11/07/25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PreferenceBallsViewController : UITableViewController {
@private
	NSInteger min_;
	NSInteger max_;
	NSInteger balls_;
}

@property(assign) NSInteger balls;

@end
