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

// Called each time we update the text
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
        // Build texture name from charecter and font name
        NSString* textureName = [NSString stringWithFormat:@"%@%c", self.fontName, c];
        
        SKSpriteNode* letter;
        if (i<self.children.count) {
            // Reuse existing nodes
            letter = (SKSpriteNode*)[self.children objectAtIndex:i];
            letter.texture = [atlas textureNamed:textureName];
            letter.size = letter.texture.size;
        } else {
            // Create a new letter node
            letter = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:textureName]];
            letter.anchorPoint = CGPointZero;
            [self addChild:letter];
        }
        
        letter.position = pos;
        
        pos.x += letter.size.width + self.letterSpacing;
        totalSize.width += letter.size.width + self.letterSpacing;
        if (totalSize.height < letter.size.height) {
            totalSize.height = letter.size.height;
        }
    }
    if (self.text.length) {
        totalSize.width -= self.letterSpacing;
    }
    
    // Centering the text
    // Calculating distance which we will move each letter
    CGPoint adjustment = CGPointMake(-totalSize.width/2, -totalSize.height/2);
    // Adding adjustment to each letter
    for (SKNode* letter in self.children) {
        letter.position = CGPointMake(letter.position.x+adjustment.x, letter.position.y+adjustment.y);
    }
}

@end
