import Foundation

struct PokemonSelected: Codable {
    var sprites: PokemonSprites
    var weight: Int
}

struct PokemonSprites: Codable {
    var front_default: String
}

class PokemonSelectedApi {
    func getData(url: String, completion: @escaping (PokemonSprites, Int) -> ()) {
        
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url){ (data, response, error) in
            guard let data = data else {return}
            
            let pokemonData = try! JSONDecoder().decode(PokemonSelected.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(pokemonData.sprites, pokemonData.weight)
                    }
        }.resume()
    }
}

