//
//  Day9.swift
//  AdventOfCode2025
//
//  Created by Marc-Antoine Malépart on 2025-12-08.
//

import Foundation
import Algorithms
import ArgumentParser
import AdventOfCodeUtilities
import RegexBuilder

struct Day9: DayCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "day9",
            abstract: "Solve day 9 puzzle"
        )
    }
    
    @Argument(
        help: "Puzzle input path",
        transform: { URL(filePath: $0, relativeTo: nil) }
    )
    var puzzleInputURL: URL
    
    func run() throws {
        let clock = ContinuousClock()
        let points = points(from: try readLines())
        
        printTitle("Part 1", level: .title1)
        let (part1Duration, largestArea) = clock.measure {
            part1(points: points)
        }
        print("What is the largest area of any rectangle you can make?", largestArea)
        print("Elapsed time:", part1Duration, terminator: "\n\n")
        
        printTitle("Part 2", level: .title1)
        let (part2Duration, part2Result) = clock.measure {
            part2(points: points)
        }
        print("Part 2:", part2Result)
        print("Elapsed time:", part2Duration)
    }
    
    private func points(from lines: [String]) -> [Point2D] {
        let regex = Regex {
            let coordinate = TryCapture {
                Optionally("-")
                
                OneOrMore(.digit)
            } transform: {
                Int($0)
            }
            
            coordinate
            
            ","
            
            coordinate
        }
        
        return lines.compactMap { line in
            guard let match = line.wholeMatch(of: regex) else {
                return nil
            }
            
            return Point2D(x: match.output.1, y: match.output.2)
        }
    }
    
    private func part1(points: [Point2D]) -> Int {
        let rectanglesAndArea: [(rectangle: Frame2D, area: Int)] = points.combinations(ofCount: 2)
            .compactMap { points in
                let rectangle = Frame2D(corners: (points[0], points[1]))
                return (rectangle, rectangle.area)
            }
        let largestRectangleAndArea = rectanglesAndArea.max(by: { $0.area < $1.area })!
        return largestRectangleAndArea.area
    }
    
    private func part2(points: [Point2D]) -> Int {
        // TODO
        return 0
    }
}

private extension Frame2D {
    var area: Int {
        (size.width + 1) * (size.height + 1)
    }
    
    init(corners: (Point2D, Point2D)) {
        let minAndMaxX = [corners.0.x, corners.1.x].minAndMax()!
        let minAndMaxY = [corners.0.y, corners.1.y].minAndMax()!
        
        let origin = Point2D(x: minAndMaxX.min, y: minAndMaxY.min)
        let size = Size2D(
            width: abs(minAndMaxX.max - minAndMaxX.min),
            height: abs(minAndMaxY.max - minAndMaxY.min)
        )
        
        self.init(origin: origin, size: size)
    }
}
