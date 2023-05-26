//
//  Athlete.swift
//  UFCAthleteListDemo
//
//  Created by 洪崧傑 on 2023/4/7.
//

import Foundation


// Create a Athlete object
class Athlete: Codable {
    var named: String
    var description: String
    var image: String
    var standing: String
    var clinch: String
    var ground: String
    var url: String
    // Implement a favorite state
    var favorite: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case named, description, image, standing, clinch, ground, url
    }
    
    init(named: String, description: String, image: String, standing: String, clinch: String, ground: String, url: String) {
        self.named = named
        self.description = description
        self.image = image
        self.standing = standing
        self.clinch = clinch
        self.ground = ground
        self.url = url
        
    }
}

struct AthleteResult: Codable {
    let athletes: [Athlete]
}
