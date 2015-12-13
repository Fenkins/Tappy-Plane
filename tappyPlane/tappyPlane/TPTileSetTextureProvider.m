//
//  TPTileSetTextureProvider.m
//  tappyPlane
//
//  Created by Fenkins on 11/12/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "TPTileSetTextureProvider.h"
#import <SpriteKit/SpriteKit.h>

@interface TPTileSetTextureProvider()
@property (nonatomic) NSMutableDictionary *tilesets;
@end

@implementation TPTileSetTextureProvider
+(instancetype)getProvider {
    static TPTileSetTextureProvider* provider = nil;

    // Everything we put in here will be protected from running at the same time in different threads
    @synchronized(self) {
        if (!provider) {
            provider = [[TPTileSetTextureProvider alloc]init];
        }
        return provider;
    }
}

-(void)loadTileSets {
    self.tilesets = [[NSMutableDictionary alloc]init];
    SKTextureAtlas* atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    // Get path for property list.
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"TilesetGraphics" ofType:@"plist"];
    // Load contents of file.
    NSDictionary *tilesetList = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    // Loop trough tileset lists.
    for (NSString* tilesetKey in tilesetList) {
        // Create dictionary of texture names.
        NSDictionary* textureList = [tilesetList objectForKey:tilesetKey];
        // Create dictionary to hold textures.
        NSMutableDictionary* textures = [[NSMutableDictionary alloc]init];
        
        for (NSString* textureKey in textureList) {
            // Get texture for keys
            SKTexture* texture = [atlas textureNamed:[textureList objectForKey:textureKey]];
            // Insert texture to textures dictionary.
            [textures setObject:texture forKey:textureKey];
        }
        
        // Add texture dictionaryes to tilesets
        [self.tilesets setObject:textures forKey:tilesetKey];
        
    }
}
@end
