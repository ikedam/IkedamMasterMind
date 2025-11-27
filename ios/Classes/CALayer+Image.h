//
//  CALayer+Image.h
//  MasterMind
//
//  Created by minidam on 11/07/10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface CALayer (Image);

+(id)layerImageNamed: (NSString*)imageName;
-(void)loadImageNamed: (NSString*)imageName; 

@end
