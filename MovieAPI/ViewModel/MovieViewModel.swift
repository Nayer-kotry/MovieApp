//
//  MovieViewModel.swift
//  MovieAPI
//
//  Created by Nayer Kotry on 28/08/2023.
//
//

import Foundation

class MovieViewModel {
 
    private var actors: [String]?
    private var directors:  [String]?
    private var writers :  [String]?
    private var creators :  [String]?
    private var castManager = MovieResultManager()

    func loadCast(id: String, info: [String], imageURL: String? = nil, completion: @escaping (([[String]?],Data?) -> Void)) {
        
        castManager.fetchDirectorsByTitleID(id: id, info: info, imageURL: imageURL) {
            let AllCast = $0
            let imageData = $1
    
            if let castt = AllCast?.cast{
                
                self.directors = self.getCastNames(type: "directors", cast: castt)
                self.writers = self.getCastNames(type: "writers", cast: castt)
                self.creators = self.getCastNames(type: "creators", cast: castt)
                
            }
        
            if let arrayOfActors = AllCast?.actorNames?.results?.cast?.edges {
                
                self.actors = arrayOfActors.map{
                    if let name =   $0?.node?.name?.nameText?.text {
                        return name
                    }
                    return ""
                    
                }
            }
            
            completion([self.actors,self.directors, self.writers, self.creators],imageData)
           
        }
    }
    
    func getCastNames(type: String, cast: CreatorResults) -> [String] {
        var array: [CreditsInfo?] = []
        var resultArray: [String] = []

        switch type {
        case "creators":
            array = cast.creators
        case "directors":
            array = cast.directors
        case "writers":
            array = cast.writers
        default:
            print("error")
        }

        if let arrayofCredits = array.compactMap({ $0?.credits }).first {
            resultArray = arrayofCredits.compactMap {
                $0?.name?.nameText?.text ?? ""
            }
        }

        return resultArray
    }
    
    func getDirectors() -> [String]{
        return self.directors ?? []
    }
    
    func getActors() -> [String]{
        return self.actors ?? []
    }
    
    func getWriters() -> [String]{
        return self.writers ?? []
    }
}




