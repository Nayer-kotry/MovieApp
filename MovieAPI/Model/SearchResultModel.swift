//
//  SearchResultModel.swift
//  MovieAPI
//
//  Created by Nayer Kotry on 13/08/2023.
//

import Foundation

struct SearchTitleJSON : Codable {
    
    let next : String?
    let entries : Int?
    let results : [Movie]?
    
}

struct Movie : Codable {
    
    let _id : String
    let id: String
    let ratingsSummary : RatingsSummary
    let primaryImage : PrimaryImage?
    let titleType : TitleType
    let titleText : TitleText
    let originalTitleText : OriginalTitleText?
    let releaseYear : ReleaseYear?
    let releaseDate : ReleaseDate?
    let runtime : Runtime?
    let plot : Plot?
    
}

struct Caption : Codable {
    
    let plainText : String?
    let __typename : String
   
}

struct PrimaryImage : Codable {
    
    let id : String
    let width : Int?
    let height : Int?
    let url : String?
    let caption: Caption?
    let __typename: String

}

struct TitleType : Codable {
    let text : String?
    let id : String
    let isSeries : Bool?
    let isEpisode : Bool?
    let __typename : String
}


struct TitleText : Codable {
   
    let text : String?
    let __typename : String
    
}


struct OriginalTitleText : Codable {
    let text : String?
    let __typename : String
}


struct ReleaseYear : Codable {
    
    let year : Int?
    let endYear : Int?
    let __typename : String
    
}


struct ReleaseDate : Codable {
    
    let day : Int?
    let month : Int?
    let year : Int?
    let __typename : String
}

struct RatingsSummary : Codable {
    let aggregateRating : Float?
    let voteCount : Int?

}

struct Runtime : Codable {
    let seconds : Int?
}

struct Plot : Codable {
    let plotText : PlotText?
}
struct PlotText: Codable {
    let plainText : String?
}
