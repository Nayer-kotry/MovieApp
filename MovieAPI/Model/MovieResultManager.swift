//
//  MovieResultManager.swift
//  MovieAPI
//
//  Created by Nayer Kotry on 16/08/2023.
//

import Foundation


protocol ActorNamesDelegate {
    func config(actorNames: ActorNames?)
    func config(data: Test?, imageData: Data?)
}


struct MovieResultManager {
    
    var actorNamesDelegate: ActorNamesDelegate?
    
  
   
    func fetchDirectorsByTitleID (id: String, info: [String], imageURL: String? = nil) {
        
        var urls : [String] = []
        for inf in info {
            urls.append("https://moviesdatabase.p.rapidapi.com/titles/\(id)/?info=\(inf)")
        }
//         urls = ["https://moviesdatabase.p.rapidapi.com/titles/\(id)/?info=extendedCast",
//                    "https://moviesdatabase.p.rapidapi.com/titles/\(id)/?info=creators_directors_writers"]
        let group = DispatchGroup()
        var parsedData = Test()
        var imageData: Data?
        
        for  (index, url) in urls.enumerated() {
            
            guard let url = URL(string: url) else {
                continue
            }
            var request = URLRequest(url: url)
            
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = [
                "X-RapidAPI-Key": "46d53d410bmshc0d6e6f6f138093p1e48cejsn4b7012c723ac",
                "X-RapidAPI-Host": "moviesdatabase.p.rapidapi.com"
            ]
            
            group.enter()
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                defer {
                    group.leave()
                }
                
                if(error != nil) {
                    print(error!)
                    return
                }
                
                if data != nil {
                    
                    
                    switch info[index]{
                        
                    case "extendedCast":
                        if let actors:ActorNames = parseJSON(data: data!, model: ActorNames.self) {
                            parsedData.actorNames = actors
                         
                        }
                        
                    case "creators_directors_writers":
                        if let res: Creators = parseJSON(data: data!, model: Creators.self){
                            parsedData.cast = res.results
                        
                        }
                        
                    default:
                        print("Unknown API type")
                        
                    }
                    
                }
                
            }
                
            task.resume()
        }
        group.enter()
        if let imageurl = imageURL {
            guard let url = URL(string: imageurl) else {
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                defer {
                    group.leave()
                }
                
                if(error != nil) {
                    print(error!)
                    return
                }
                
                if data != nil {
                    imageData = data
                }
            }
            task.resume()
        }
        group.notify(queue: .main) {
  
            self.actorNamesDelegate?.config(data: parsedData, imageData: imageData)
        }
        
    }
    
    func parseJSON<T: Codable>(data: Data, model: T.Type) -> T?{
  
        let decoder = JSONDecoder()
        do{
            let parsed = try decoder.decode(model.self, from: data)
            return parsed
        }
        catch{
            print(error)
            return nil
        }
        
     
    }
    
    
       
//    func fetchByTitleID (id: String) -> ActorNames? {
//
//        let urlString = "https://moviesdatabase.p.rapidapi.com/titles/\(id)/?info=extendedCast"
//
//        var decodedData : ActorNames? = nil
//        let group = DispatchGroup()
//        let session = URLSession.shared
//        if let url = URL(string: urlString) {
//
//
//            var request = URLRequest(url: url)
//
//            request.httpMethod = "GET"
//            request.allHTTPHeaderFields = [
//                "X-RapidAPI-Key": "46d53d410bmshc0d6e6f6f138093p1e48cejsn4b7012c723ac",
//                "X-RapidAPI-Host": "moviesdatabase.p.rapidapi.com"
//            ]
//
//            //MARK: - first API call
//            group.enter()
//            let task1 = session.dataTask(with: request) { data, response, error in
//
//                if(error != nil) {
//                    print(error!)
//                    return
//                }
//
//                if data != nil {
//
//                    let decoder = JSONDecoder()
//                    do{
//                         decodedData = try decoder.decode(ActorNames.self, from: data!)
//                        print("sdcs")
//                        self.actorNamesDelegate?.config(actorNames: decodedData)
//                    }
//                    catch {
//                        print(error)
//                        return
//                    }
//                    }
//
//
//
//
//            }
//            task1.resume()
//
//            //MARK: - Second API call
//
//            let task2 = session.dataTask(with: request) { data, response, error in
//
//                if(error != nil) {
//                    print(error!)
//                    return
//                }
//
//                if data != nil {
//
//                    let decoder = JSONDecoder()
//                    do{
//                         decodedData = try decoder.decode(ActorNames.self, from: data!)
//                        print("sdcs")
//                        self.actorNamesDelegate?.config(actorNames: decodedData)
//                    }
//                    catch {
//                        print(error)
//                        return
//                    }
//                    }
//
//
//
//
//            }
//            task1.resume()
//        }
//
//        return decodedData
//    }
    

}
