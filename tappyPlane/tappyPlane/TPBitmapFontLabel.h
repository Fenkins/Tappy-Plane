//
//  TPBitmapFontLabel.h
//  tappyPlane
//
//  Created by Fenkins on 07/12/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TPBitmapFontLabel : SKNode
@property (nonatomic) NSString* fontName;
@property (nonatomic) NSString* text;
@property (nonatomic) CGFloat letterSpacing;

-(instancetype)initWithText:(NSString*)text andFontName:(NSString*)fontName;
@end
