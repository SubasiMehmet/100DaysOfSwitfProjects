//
//  Petition.swift
//  Project7
//
//  Created by Mehmet Subaşı on 4.07.2022.
//

import Foundation

protocol Copying {
    init(original: Self)
}

//Concrete class extension
extension Copying {
    func copy() -> Self {
        return Self.init(original: self)
    }
}

// MARK: - Same 'title's with the json page
struct Petition: Codable, Copying {
 
    var title: String
    var body: String
    var signatureCount: Int
    
    //Copying protocol
    init(original: Petition) {
        title = original.title
        body = original.body
        signatureCount = original.signatureCount
    }
}


extension Array where Element: Copying {
    func clone() -> Array {
        var copiedArray = Array<Element>()
        for element in self {
            copiedArray.append(element.copy())
        }
        return copiedArray
    }
}
