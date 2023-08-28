//
//  MovieInfoModel.swift
//  MovieAPI
//
//  Created by Nayer Kotry on 16/08/2023.
//

import Foundation


struct MovieCredits {
    
    var actorNames: [String?]
    let directors: [String]
    let writers: [String]
    let creators: [String]

    
}

struct Test {
    
    var actorNames: ActorNames?
    var cast: CreatorResults?

    
}

//MARK: - Actors data structure

struct ActorNames: Codable {
    let results: Results?

    var actorNames: [String?] {
        return results?.cast?.edges?.compactMap { $0?.node?.name?.nameText?.text } ?? []
    }
    
}



struct Results: Codable {
    let cast: Cast?
}

struct Cast: Codable {
    let edges: [Edge?]?
}

struct Edge: Codable {
    let node: Node?
}

struct Node: Codable {
    let name: Name?
}

struct Name: Codable {
    let nameText: NameText?
}

struct NameText: Codable {
    let text: String?
}


//MARK: - Writers, creators, directors data structure


//struct creators: Codable{
//    let results: CreatorResults
//    var creators :
//
//    var directors:
//    var writers:
//}
struct Creators: Codable {
    let results: CreatorResults
}

struct CreatorResults: Codable {
    let creators : [CreditsInfo?]
    let directors: [CreditsInfo?]
    let writers: [CreditsInfo?]
    
}



struct CreditsInfo: Codable{
    let totalCredits: Int?
    let credits: [Credits?]
}

struct Credits: Codable{
    
    let name: Name?
}
