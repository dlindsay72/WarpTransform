//
//  GameScene.swift
//  WarpTransform
//
//  Created by Dan Lindsay on 2017-04-25.
//  Copyright © 2017 Dan Lindsay. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var spaceShip: SKSpriteNode!
    var warpType = 0
    
    var src = [
        
        //bottom row: left, center, right
        vector_float2(0.0, 0.0),
        vector_float2(0.5, 0.0),
        vector_float2(1.0, 0.0),
        
        // middle row: left, center, right
        vector_float2(0.0, 0.5),
        vector_float2(0.5, 0.5),
        vector_float2(1.0, 0.5),
        
        // top row: left, center, right
        vector_float2(0.0, 1.0),
        vector_float2(0.5, 1.0),
        vector_float2(1.0, 1.0)
        
    ]
    
    
    override func didMove(to view: SKView) {
        
        spaceShip = SKSpriteNode(imageNamed: "Spaceship")
        addChild(spaceShip)
        
        let warp = SKWarpGeometryGrid(columns: 2, rows: 2, sourcePositions: src, destinationPositions: src)
        
        spaceShip.warpGeometry = warp
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //create a destination transform by copying the source transform
        var dst = src
        
        //this is where we'll be modifying the destination transform
        switch warpType {
            
        case 0:
            //stretch the nose up
            dst[7] = vector_float2(0.5, 1.5)
            
        case 1:
            //stretch the wings down
            dst[0] = vector_float2(0, -0.5)
            dst[2] = vector_float2(1, -0.5)
            
        case 2:
            //squash ship vertically
            dst[0] = vector_float2(0.0, 0.25)
            dst[1] = vector_float2(0.5, 0.25)
            dst[2] = vector_float2(1.0, 0.25)
            
            dst[6] = vector_float2(0.0, 0.75)
            dst[7] = vector_float2(0.5, 0.75)
            dst[8] = vector_float2(1.0, 0.75)
            
        case 3:
            // flip left to right
            dst[3] = vector_float2(1.0, 0.0)
            dst[5] = vector_float2(0.0, 0.0)
            
            dst[3] = vector_float2(1.0, 0.5)
            dst[5] = vector_float2(0.0, 0.5)
            
            dst[6] = vector_float2(1.0, 1)
            dst[8] = vector_float2(0.0, 1)
            
        default:
            break
        }
        
        //create a new warp geometry by mapping from src to dst
        let newWarp = SKWarpGeometryGrid(columns: 2, rows: 2, sourcePositions: src, destinationPositions: dst)
        
        //pull out the existing warp geometry so we have something to animate back to
        let oldWarp = spaceShip.warpGeometry!
        
        //try to create an SKAction with these two warps; each will animate over 0.5 seconds
        if let action = SKAction.animate(withWarps: [newWarp, oldWarp], times: [0.5, 1]) {
            
            // run it on the spaceship sprite
            spaceShip.run(action)
        }
        
        //add 1 to the warp type so that we get a different transformation next time
        warpType += 1
        
        //if we're higher than 3, warp back to 0
        if warpType > 3 {
            warpType = 0
        }
        
    }
    
    
}























