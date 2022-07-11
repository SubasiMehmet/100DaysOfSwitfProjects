//
//  Petitions.swift
//  Project7
//
//  Created by Mehmet Subaşı on 4.07.2022.
//

import Foundation


//MARK: - String of 'results' need to be same in json page
struct Petitions: Codable {
    var results: [Petition]
}
