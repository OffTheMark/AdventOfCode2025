//
//  Day7.swift
//  AdventOfCode2025
//
//  Created by Marc-Antoine Malépart on 2025-12-07.
//

import Foundation
import ArgumentParser
import AdventOfCodeUtilities

struct Day7: DayCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "day7",
            abstract: "Solve day 7 puzzle"
        )
    }
    
    @Argument(
        help: "Puzzle input path",
        transform: { URL(filePath: $0, relativeTo: nil) }
    )
    var puzzleInputURL: URL
    
    func run() throws {
        let clock = ContinuousClock()
        let grid = Grid2D<Location>(rawValue: try readFile())
        
        printTitle("Part 1", level: .title1)
        let (part1Duration, totalNumberOfSplits) = clock.measure {
            part1(grid: grid)
        }
        print("How many times will the beam be split?", totalNumberOfSplits)
        print("Elapsed time:", part1Duration, terminator: "\n\n")
    }
    
    private func part1(grid: Grid2D<Location>) -> Int {
        let startingPoint = grid.points.first { grid[$0] == .start }!
        var splits = 0
        var beams: Set<Point2D> = [startingPoint]
        
        for _ in 0 ..< grid.frame.maxY {
            var nextBeams = Set<Point2D>()
            
            for beam in beams {
                let pointUnder = beam.applying(.down)
                if grid[pointUnder] == .splitter {
                    splits += 1
                    
                    nextBeams.formUnion(
                        [
                            pointUnder.applying(.left),
                            pointUnder.applying(.right)
                        ]
                    )
                    continue
                }
                
                nextBeams.insert(pointUnder)
            }
            beams = nextBeams
        }
        
        return splits
    }
}

private enum Location: Character {
    case start = "S"
    case splitter = "^"
}

private struct Path: Hashable {
    var points: [Point2D]
    var splitters: Set<Point2D>
    var lastSplitter: Point2D?
    
    var pointOrigin: PointOrigin {
        PointOrigin(point: points.last!, lastSplitter: lastSplitter)
    }
    
    init(startingPoint: Point2D) {
        self.points = [startingPoint]
        self.splitters = []
        self.lastSplitter = nil
    }
    
    struct PointOrigin: Hashable {
        let point: Point2D
        let lastSplitter: Point2D?
    }
}
