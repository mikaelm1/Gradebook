//
//  Grade.swift
//  Gradebook
//
//  Created by Mikael Mukhsikaroyan on 4/4/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit

struct Grade {
    
    enum GradeLetter: String {
        case A = "A"
        case AMinus = "A-"
        case BPlus = "B+"
        case B = "B"
        case BMinus = "B-"
        case CPlus = "C+"
        case C = "C"
        case CMinus = "C-"
        case DPlus = "D+"
        case D = "D"
        case DMinus = "D-"
        case F = "F"
        
        static let allGrades = [A, AMinus, BPlus, B, BMinus, CPlus, C, CMinus, DPlus, D, DMinus, F]
        
        func getGradeValue() -> Double {
            switch self {
            case .A:
                return 4.0
            case .AMinus:
                return 3.7
            case .BPlus:
                return 3.3
            case .B:
                return 3.0
            case .BMinus:
                return 2.7
            case .CPlus:
                return 2.3
            case .C:
                return 2.0
            case .CMinus:
                return 1.7
            case .DPlus:
                return 1.3
            case .D:
                return 1.0
            case .DMinus:
                return 0.7
            case .F:
                return 0
            }
        }
    }
    
    
}




