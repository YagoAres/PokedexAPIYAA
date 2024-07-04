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
    
    func fetchPokemonSprite(for pokemon: PokemonResult, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: pokemon.url) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching sprite for \(pokemon.name):", error)
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
                
                guard let spriteURL = URL(string: pokemonData.sprites.frontDefault) else {
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
                print("Error decoding JSON for \(pokemon.name):", jsonError)
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
    let sprites: Sprites
    
    struct Sprites: Codable {
        let frontDefault: String
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
}
