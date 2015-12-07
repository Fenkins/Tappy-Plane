//
//  TPBitmapFontLabel.m
//  tappyPlane
//
//  Created by Fenkins on 07/12/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "TPBitmapFontLabel.h"

@implementation TPBitmapFontLabel
-(instancetype)initWithText:(NSString *)text andFontName:(NSString *)fontName {
    if (self = [super init]) {
        _text = text;
        _fontName = fontName;
        _letterSpacing = 2.0;
        [self updateText];
    }
    return self;
}

-(void)setText:(NSString *)text {
    if (_text != text) {
        _text = text;
        [self updateText];
    }
}

-(void)setFontName:(NSString *)fontName {
    if (_fontName != fontName) {
        _fontName = fontName;
        [self updateText];
    }
}

-(void)setLetterSpacing:(CGFloat)letterSpacing {
    if (_letterSpacing != letterSpacing) {
        _letterSpacing = letterSpacing;
        [self updateText];
    }
}

-(void)updateText {

    // Remove unused nodes.
    if (self.text.length < self.children.count) {
        for (NSUInteger i = self.children.count; i > self.text.length; i--) {
            [[self.children objectAtIndex:i-1]removeFromParent];
        }
    }
    
    CGPoint pos = CGPointZero;
    CGSize totalSize = CGSizeZero;
    SKTextureAtlas* atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    // Looping trought the charecters in text
    for (NSUInteger i = 0; i < self.text.length; i++) {
        // Get charecter in text for current pos
        unichar c = [self.text characterAtIndex:i];
    }
}

@end
