//
//  ResultsManager.swift
//  MovieAPI
//
//  Created by Nayer Kotry on 13/08/2023.
//

import Foundation


//protocol SearchManagerProtocol {
//    func config(results: Movies)
//}

protocol GenreManagerProtocol {
    func config(genres : [String?])
}

struct ResultsManager {
//    var searchDelegate: SearchManagerProtocol?
    var genreDelegate : GenreManagerProtocol?
    
    func fetchAllMovies(genre: String? = nil, completion: @escaping ((Movies) -> Void)) {
        var url = "https://moviesdatabase.p.rapidapi.com/titles?info=base_info"
        if genre != nil {
            url += "&genre=\(genre!)"
        }
//        performFetch(with : url, api : "showAllMovies", completion: )
        performFetch(with: url, api: "showAllMovies") { movies in
            completion(movies)
        }
    }
    
    func fetchMovieSearch( title : String, genre: String? = nil, completion: @escaping ((Movies) -> Void)) {

        let formattedTitle = title.replacingOccurrences(of: " ", with: "%20")
        var url = "https://moviesdatabase.p.rapidapi.com/titles/search/title/\(formattedTitle)?exact=false&info=base_info"
        
        if genre != nil {
            url += "&genre=\(genre!)"
        }
     
        performFetch(with: url, api: "searchTitle") { movies in
            completion(movies)
        }
    }

    func fetchGenres(completion: @escaping ((Genres) -> Void)) {
        let url = "https://moviesdatabase.p.rapidapi.com/titles/utils/genres"
//        performFetch(with : url, api : "utilGenres")
        performFetchGenres(with : url, api : "utilGenres"){ genres in
            completion(genres)
            
        }
    }
    
    private func performFetchGenres(with : String, api : String, completion: @escaping ((Genres) -> Void)){
        if let url = URL(string : with) {
            
            let session = URLSession(configuration: .default)
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = [
                "X-RapidAPI-Key": "46d53d410bmshc0d6e6f6f138093p1e48cejsn4b7012c723ac",
                "X-RapidAPI-Host": "moviesdatabase.p.rapidapi.com"
            ]
            
            let task = session.dataTask(with: request) {
                data, response, error in
                
                
                if (error != nil) {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let APIresults = self.parseGenresJSON(genreData: safeData) {
                        completion(Genres(results: APIresults))
                    }
                }
            }
            task.resume()
        }
    }
    private func performFetch( with urlString : String, api: String, completion: @escaping ((Movies) -> Void)){

    if let url = URL(string : urlString) {
        
        let session = URLSession(configuration: .default)

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "X-RapidAPI-Key": "46d53d410bmshc0d6e6f6f138093p1e48cejsn4b7012c723ac",
            "X-RapidAPI-Host": "moviesdatabase.p.rapidapi.com"
        ]
     
        let task = session.dataTask(with: request) {
            data, response, error in

            
            if (error != nil) {
                print(error!)
                return
            }
            
            if let safeData = data {
                switch api {
                case "searchTitle":
                    if let APIresults = self.parseMoviesSearchJSON(searchTitleData: safeData) {
//                        self.searchDelegate?.config(results: APIresults)
                        completion(APIresults)
                    }
                case "utilGenres":
                    if let APIresults = self.parseGenresJSON(genreData: safeData) {
                        self.genreDelegate?.config(genres: APIresults)
                    }
                case "showAllMovies" :
                    if let APIresults = self.parseMoviesSearchJSON(searchTitleData: safeData) {
//                        self.searchDelegate?.config(results: APIresults)
                        completion(APIresults)
                        
                    }
                default:
                    print("Unknown API type")
                    
                }
                
            }
            
        }
        task.resume()
    }
}

    func parseMoviesSearchJSON (searchTitleData : Data) -> Movies? {
        
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode( SearchTitleJSON.self, from: searchTitleData)
            if let dataExists = decodedData.results{
                let movies = dataExists.map({movie in
                    let rating = movie.ratingsSummary.aggregateRating
                    let duration = movie.runtime?.seconds
                    let plot = movie.plot?.plotText?.plainText
                    let imageUrl = movie.primaryImage?.url
                    return MovieCell(id: movie.id, title: movie.titleText.text ?? " ", releaseYear: movie.releaseYear?.year, rating: rating, duration: duration, plot: plot, image: imageUrl)
                    
                })
                let results = Movies(results: movies)
                return results
                
            }
            
            return Movies(results: [])
           
        }
        
        catch {
            print(error)
            return nil
        }
    }
    func parseGenresJSON (genreData : Data) -> [String?]? {
        
        let decoder = JSONDecoder()
        do{
            
            return try decoder.decode( [String: [String?]].self, from: genreData)["results"]
             
        }
        
        catch {
            print(error)
            return []
        }
    }
}
