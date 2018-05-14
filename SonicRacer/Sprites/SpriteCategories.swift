//
//
//  SpriteCategories.swift
//  Tilt Maze
//
//  Created by Butler, David  on 12/24/13.
//  Copyright (c) 2014 DHB Worlds. All rights reserved.
//

import Foundation

public enum CollisionType: UInt32  {
    case player = 0
    case wall = 1
    case pointyWall = 2
    case missle = 3
    case spaceMine = 4
    case cannon = 5
    case laser = 6
    case enemyShip = 7
    case meteor = 8
    case rotatingWall = 9
}

public enum ObstacleType : Int {
    case pointyWallObstacle = 1
    case alienShipObstacle = 2
    case greenLightWallObstacle = 3
    case meteorObstacle = 4
    case rotatingWallObstacle = 5
}


public enum ConeOrientation :Int
{
    case ConeOrientationLeft = 1
    case ConeOrientationRight = 2
}

enum ScrapeDirection : Int {
    case scrapeLeft = 1
    case scrapeRight = 2
}
