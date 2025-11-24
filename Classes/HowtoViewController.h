//
//  HowtoController.h
//  MasterMind
//
//  Created by minidam on 11/06/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface HowtoViewController : UIViewController<UIWebViewDelegate> {
@private
	UIWebView* webView_;
	void (^done_)(void);
}

@property(retain) IBOutlet UIWebView* webView;
@property(copy) void (^done)(void);

- (IBAction)onDonePressed: (id)sender;

@end
