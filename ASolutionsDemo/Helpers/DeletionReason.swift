//
//  DeletionReason.swift
//  ASolutionsDemo
//
//  Created by Farid Rzayev on 25.09.24.
//


enum DeletionReason: String, CaseIterable {
    case lostCard = "Lost Card"
    case stolenCard = "Stolen Card"
    case damagedCard = "Damaged Card"
    case noLongerNeeded = "No Longer Needed"
    case other = "Other"

    var description: String {
        return self.rawValue
    }
}
