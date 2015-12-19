//
//  TPTileSetTextureProvider.m
//  tappyPlane
//
//  Created by Fenkins on 11/12/15.
//  Copyright © 2015 Fenkins. All rights reserved.
//

#import "TPTileSetTextureProvider.h"

@interface TPTileSetTextureProvider()
@property (nonatomic) NSMutableDictionary *tilesets;
@property (nonatomic) NSDictionary *currentTileset;
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

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadTileSets];
        [self randomizeTileSet];
    }
    return self;
}

-(void)randomizeTileSet {
    NSArray* tileSetkeys = [self.tilesets allKeys];
    NSString* key = [tileSetkeys objectAtIndex:arc4random_uniform((uint)tileSetkeys.count)];
    self.currentTileset = [self.tilesets objectForKey:key];
}

-(SKTexture*)getTextureForKey:(NSString *)key {
    return [self.currentTileset objectForKey:key];
}

-(void)loadTileSets {
    self.tilesets = [[NSMutableDictionary alloc]init];
    SKTextureAtlas* atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    // Get path for property list.
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"TileSetGraphics" ofType:@"plist"];
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
