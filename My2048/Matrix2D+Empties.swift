//
//  Matrix2D+Empties.swift
//
//  Created by Exey Panteleev on 09/04/15.
//  Copyright (c) 2015 Exey Panteleev. All rights reserved.
//

import Foundation

extension Matrix2D {
    
    // Returns an array of indices (column, row) of all free positions
    func getEmpties(_ isEmpty: (T?) -> Bool) -> [(Int, Int)] {
        var arr = [(Int, Int)]()
        for col in 0 ..< rows {
            for row in 0 ..< columns {
                if isEmpty(self[col, row]) {
                    arr.append((col, row))
                }
            }
        }
        return arr
    }
    
}
