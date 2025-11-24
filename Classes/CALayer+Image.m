//
//  CALayer+Image.m
//  MasterMind
//
//  Created by minidam on 11/07/10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CALayer+Image.h"


@implementation CALayer(Image)

+(id)layerImageNamed: (NSString*)imageName{
	CALayer* obj = [CALayer layer];
	[obj loadImageNamed: imageName];
	return obj;
}

- (void)loadImageNamed: (NSString*)imageName{
	UIImage* image = [UIImage imageNamed: imageName];
	self.contents = (id)image.CGImage;
	CGPoint center = self.position;
	self.frame = CGRectMake(
							0,
							0,
							image.size.width,
							image.size.height
							);
	self.position = center;
}


@end
