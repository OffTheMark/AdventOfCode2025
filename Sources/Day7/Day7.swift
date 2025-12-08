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
        
        printTitle("Part 2", level: .title1)
        let (part2Duration, numberOfTimelines) = clock.measure {
            part2(grid: grid)
        }
        print("In total, how many different timelines would a single tachyon particle end up on?", numberOfTimelines)
        print("Elapsed time:", part2Duration)
    }
    
    private func part1(grid: Grid2D<Location>) -> Int {
        let startingPoint = grid.points.first { grid[$0] == .start }!
        var splits = 0
        var beams: Set<Point2D> = [startingPoint]
        
        for _ in 0 ..< grid.frame.maxY {
            var nextBeams = Set<Point2D>()
            
            for beam in beams {
                let pointUnder = beam.applying(.down)
                let hasMetSplitter = grid[pointUnder] == .splitter
                if hasMetSplitter {
                    splits += 1
                }
                let nextTips: [Point2D] = if hasMetSplitter {
                    [pointUnder.applying(.left), pointUnder.applying(.right)]
                }
                else {
                    [pointUnder]
                }
                
                nextBeams.formUnion(nextTips)
            }
            beams = nextBeams
        }
        
        return splits
    }
    
    private func part2(grid: Grid2D<Location>) -> Int {
        let startingPoint = grid.points.first { grid[$0] == .start }!
        
        let timelines = recursiveMemoize { (timelines: (Point2D) -> Int, beam: Point2D) in
            if beam.y >= grid.frame.maxY {
                return 1
            }
            
            let pointUnder = beam.applying(.down)
            let nextBeams: [Point2D] = if grid[pointUnder] == .splitter {
                [pointUnder.applying(.left), pointUnder.applying(.right)]
            }
            else {
                [pointUnder]
            }
            
            return nextBeams.reduce(into: 0) { partialResult, nextBeam in
                partialResult += timelines(nextBeam)
            }
        }
        
        return timelines(startingPoint)
    }
}

private enum Location: Character {
    case start = "S"
    case splitter = "^"
}

private struct Timeline: Hashable {
    let beam: Point2D
    var metSplitters = Set<Point2D>()
}
