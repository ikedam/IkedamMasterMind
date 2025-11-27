//
//  HowtoController.m
//  MasterMind
//
//  Created by minidam on 11/06/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HowtoViewController.h"
#import "UIBlockAlertView.h"

@interface HowtoViewController ();


@end

@implementation HowtoViewController

@synthesize webView=webView_;
@synthesize done=done_;

- (id)init{
	if((self = [super init]) != nil){
		[[NSBundle mainBundle] loadNibNamed: @"HowtoViewController"
									  owner: self
									options: nil
		 ];
		NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
		NSURL *url = [NSURL fileURLWithPath:path];
		NSURLRequest *req = [NSURLRequest requestWithURL:url];
		[self.webView loadRequest:req];		
	}
	return self;
}


- (void)dealloc{
	self.done = nil;
	self.webView.delegate = nil;
	self.webView = nil;
	
	[super dealloc];
}

- (IBAction)onDonePressed: (id)sender{
	if(self.done != nil){
		(self.done)();
	}
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType{
	if(![@"file" isEqual: [[request URL] scheme]]){
		[[UIApplication sharedApplication] openURL: [request URL]];
		return NO;
	}
	return YES;
}

@end
