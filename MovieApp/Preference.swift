//
//  Preference.swift
//  MovieApp
//
//  Created by Midhun on 22/08/24.
//

import Foundation

func saveFavorite(movie: MovieData) {
    var favorites = getFavoriteMovies()
    favorites.append(movie.title)
    UserDefaults.standard.set(favorites, forKey: "favoriteMovies")
}

func removeFavorite(movie: MovieData) {
    var favorites = getFavoriteMovies()
    favorites.removeAll { $0 == movie.title }
    UserDefaults.standard.set(favorites, forKey: "favoriteMovies")
}

func getFavoriteMovies() -> [String] {
    return UserDefaults.standard.stringArray(forKey: "favoriteMovies") ?? []
}
