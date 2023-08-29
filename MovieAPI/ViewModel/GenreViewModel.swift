//
//  GenreViewModel.swift
//  MovieAPI
//
//  Created by Nayer Kotry on 28/08/2023.
//

import Foundation
class GenreViewModel {
    private var manager = ResultsManager()
    private var genres: Genres?
    
    func loadGenres(completion: ((_ g: Genres?)-> Void)?){

        manager.fetchGenres() { genres in
            self.genres = genres
            completion?(genres)
        }

    }
    func getGenres() -> Genres? {
        return self.genres
    }
    
}
