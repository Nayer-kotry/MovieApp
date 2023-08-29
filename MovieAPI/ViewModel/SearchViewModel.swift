//
//  SearchViewModel.swift
//  MovieAPI
//
//  Created by Nayer Kotry on 28/08/2023.
//

import Foundation

class SearchViewModel {
    
    private var movies : Movies = Movies(results: [])
    private var manager = ResultsManager()

    
    func loadData(withGenre: String? = nil,completion: (() -> Void)?) {
        manager.fetchAllMovies(genre: withGenre) { movies in
            self.movies = movies
            completion?()
        }
    }
    
    func loadDataFromSearchWith(Genre: String? = nil, title: String, completion: (() -> Void)?){
        manager.fetchMovieSearch(title: title, genre: Genre){ movies in
            self.movies = movies
            completion?()
        }
    }
    
    func getMoviesCount() -> Int {
        return movies.results.count
    }
    
 
    
    func getMovie(at indexPath: Int) -> MovieCell {
        return movies.results[indexPath]
    }
}
