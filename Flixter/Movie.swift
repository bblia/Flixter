//
//  Movie.swift
//  Flixter
//
//  Created by Lia Zadoyan on 9/15/17.
//  Copyright © 2017 Lia Zadoyan. All rights reserved.
//

import UIKit

class Movie: NSObject {
    
    var title: String?
    var overview: String?
    var lowResPoster: String?
    var highResPoster: String?
    
    init(data: NSDictionary) {
        if let movieTitle = data["title"] as? String {
            self.title = movieTitle
        }
        
        if let movieOverview = data["overview"] as? String {
            self.overview = movieOverview
        }
        
        if let posterPath = data["poster_path"] as? String {
            let basePath = "https://image.tmdb.org/t/p/"
            self.lowResPoster = "\(basePath)w92\(posterPath)"
            self.highResPoster = "\(basePath)original\(posterPath)"
        }
    }
}
