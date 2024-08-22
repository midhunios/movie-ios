//
//  MovieData.swift
//  MovieApp
//
//  Created by Midhun on 22/08/24.
//

import Foundation
import SwiftyJSON

struct MovieData {
    let title: String
    let year: String
    let poster: String
    let imdbID: String
    
    init(json: JSON) {
        self.title = json["Title"].stringValue
        self.year = json["Year"].stringValue
        self.poster = json["Poster"].stringValue
        self.imdbID = json["imdbID"].stringValue
    }
}

