import UIKit

class PokemonAPI {
    
    static let shared = PokemonAPI()
    
    let baseURL = "https://pokeapi.co/api/v2/"
    
    func fetchPokemonNames(completion: @escaping ([String]?) -> Void) {
        guard let url = URL(string: "\(baseURL)pokemon?limit=151&offset=0") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching pokemon names:", error)
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let pokemonList = try decoder.decode(PokemonListResponse.self, from: data)
                let pokemonNames = pokemonList.results.map { $0.name.capitalized }
                completion(pokemonNames)
            } catch let jsonError {
                print("Error decoding JSON:", jsonError)
                completion(nil)
            }
        }.resume()
    }


    func fetchPokemonImageURL(for pokemonName: String, completion: @escaping (UIImage?) -> Void) {

        guard let url = URL(string: "\(baseURL)pokemon/\(pokemonName.lowercased())/") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching sprite for \(pokemonName):", error)
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let pokemonData = try decoder.decode(Pokemon.self, from: data)
                
                guard let spriteURL = URL(string: pokemonData.pokemonResources.imageURL) else {
                    completion(nil)
                    return
                }
                
                URLSession.shared.dataTask(with: spriteURL) { spriteData, _, _ in
                    if let spriteData = spriteData, let sprite = UIImage(data: spriteData) {
                        completion(sprite)
                    } else {
                        completion(nil)
                    }
                }.resume()
                
            } catch let jsonError {
                print("Error decoding JSON for \(pokemonName):", jsonError)
                completion(nil)
            }
        }.resume()
    }
}

struct PokemonListResponse: Codable {
    let results: [PokemonResult]
}

struct PokemonResult: Codable {
    let name: String
    let url: String
}

struct Pokemon: Codable {
    let pokemonResources: PokemonResources

    enum CodingKeys: String, CodingKey {
        case pokemonResources = "sprites"
    }

    struct PokemonResources: Codable {
        let imageURL: String

        enum CodingKeys: String, CodingKey {
            case imageURL = "front_default"
        }
    }
}


//TODO: Convertir el PokemonAPI en un repostory
//TODO: Convertir el fetchPokemonNames y el fetchPokemonImageURL a use cases independientes (UseCase, Datasource, Worker)
//TODO: Tenemos un objeto para los names (PokemonResult) y otro para la url (Pokemon.PokemonResources) esto objectos de red,
//vamos a crear un objeto de dominio que combine ambos, y el controller solo sepa de la existencia del objeto de dominio


//TODO: OPTIONAL Crear Network service para pokemon API
