//
//  Services.swift
//  Market
//
//  Created by Erick Ayala Delgadillo on 07/06/22.
//

import Foundation

struct Services: Codable {
    
    let id: Int
    let title: String
    let description: String
    let image: String
    let category: String
    let owner: String
    let resume: String
    let experience: String
    let schedule: String
    let address: String
    let telephone: String
    let location: [Location]
    
}
