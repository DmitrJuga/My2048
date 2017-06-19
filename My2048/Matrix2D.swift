//
//  Matrix.swift
//
//  Created by DmitrJuga on 09.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//


import Foundation

struct Matrix2D<T> {
    
    let columns: Int, rows: Int
    fileprivate var grid: [T?]
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        grid = [T?](repeating: nil, count: columns * rows)
    }
    
    func indexIsValid(column col: Int, row: Int) -> Bool {
        return row >= 0 && row < rows &&
               col >= 0 && col < columns
    }
    
    subscript (col: Int, row: Int) -> T? {
        get {
            assert(indexIsValid(column: col, row: row), "Index out of range")
            return grid[row * columns + col]
        }
        set {
            assert(indexIsValid(column: col, row: row), "Index out of range")
            grid[row * columns + col] = newValue
        }
    }
    
}
