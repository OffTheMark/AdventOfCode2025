//
//  Day4.swift
//  AdventOfCode2025
//
//  Created by Marc-Antoine Malépart on 2025-12-04.
//


import Foundation
import Algorithms
import ArgumentParser
import AdventOfCodeUtilities

struct Day4: DayCommand {
    @Argument(
        help: "Puzzle input path",
        transform: { URL(filePath: $0, relativeTo: nil) }
    )
    var puzzleInputURL: URL
    
    func run() throws {
        let grid = Grid2D<Square>(rawValue: try readFile())
        let clock = ContinuousClock()
        
        printTitle("Part 1", level: .title1)
        let (part1Duration, numberOfRollsAccessibleByForklift) = clock.measure {
            part1(grid: grid)
        }
        print("How many rolls of paper can be accessed by a forklift?", numberOfRollsAccessibleByForklift)
        print("Elapsed time:", part1Duration, terminator: "\n\n")
        
        
        printTitle("Part 2", level: .title1)
        let (part2Duration, numberOfRemovableRolls) = clock.measure {
            part2(grid: grid)
        }
        print(
            "How many rolls of paper in total can be removed by the Elves and their forklifts?",
            numberOfRemovableRolls
        )
        print("Elapsed time:", part2Duration)
    }
    
    private func part1(grid: Grid2D<Square>) -> Int {
        grid.points.count(where: { point in
            grid.canBeAccessedByForklift(at: point)
        })
    }
    
    private func part2(grid: Grid2D<Square>) -> Int {
        // TODO
        0
    }
}

private enum Square: Character {
    case roll = "@"
    case empty = "."
}

private extension Grid2D where Value == Square {
    func canBeAccessedByForklift(at point: Point2D) -> Bool {
        let directions: [Translation2D] = [
            .up,
            .upRight,
            .right,
            .downRight,
            .down,
            .downLeft,
            .left,
            .upLeft,
        ]
        
        guard self[point] == .roll else {
            return false
        }
        
        let adjacentRolls = directions.count(where: { translation in
            self[point.applying(translation)] == .roll
        })
        return adjacentRolls < 4
    }
}
