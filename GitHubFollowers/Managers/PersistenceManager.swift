//
//  PersistenceManager.swift
//  GitHubFollowers
//
//  Created by Federico Nellen on 18.02.20.
//

import Foundation

enum PersistenceActionType{
    case add, remove
}

enum PersistenceManager{
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favourites = "favourites"
    }
    
    static func update(whit favourite : Follower, actionType: PersistenceActionType, completed: @escaping (GFError?)-> Void){
        retrieveFavourites { (result) in
            switch result{
            case .success(var favourites):
                
                switch actionType {
                case .add:
                    guard !favourites.contains(favourite) else{
                        completed(.alreadyInFavourites)
                        return
                    }
                    favourites.append(favourite)
                    
                case .remove:
                    favourites.removeAll {$0.login == favourite.login}
                }
                completed(save(favourites: favourites))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveFavourites(completed: @escaping (Result<[Follower], GFError>) -> Void){
        guard let favouritesData = defaults.object(forKey: Keys.favourites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favourites = try decoder.decode([Follower].self, from: favouritesData)
            completed(.success(favourites))
        } catch {
            completed(.failure(.unableToFavourite))
        }
    }
    
    static func save(favourites: [Follower])->GFError?{
        do{
            let encoder = JSONEncoder()
            let encodedFavourites = try encoder.encode(favourites)
            defaults.set(encodedFavourites, forKey: Keys.favourites)
            return nil
        }catch{
            return .unableToFavourite
        }
    }
}
