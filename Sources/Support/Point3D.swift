//
//  Point3D.swift
//  AdventOfCode2025
//
//  Created by Marc-Antoine Malépart on 2025-12-08.
//

import Foundation

// MARK: Point3D

struct Point3D: Hashable {
    var x: Int
    var y: Int
    var z: Int
    
    func euclidianDistance(to other: Point3D) -> Double {
        let coordinateKeyPaths: [KeyPath<Point3D, Int>] = [
            \.x,
            \.y,
            \.z,
        ]
        let sumOfSquareDistances = coordinateKeyPaths.reduce(into: Double.zero) { partialResult, keyPath in
            partialResult += pow(Double(self[keyPath: keyPath] - other[keyPath: keyPath]), 2)
        }
        
        return sqrt(sumOfSquareDistances)
    }
    
    func applying(_ translation: Translation3D) -> Point3D {
        Self(x: x + translation.deltaX, y: y + translation.deltaY, z: z + translation.deltaZ)
    }
    
    static let zero = Self(x: 0, y: 0, z: 0)
}

struct Translation3D: Hashable {
    var deltaX: Int
    var deltaY: Int
    var deltaZ: Int
}
