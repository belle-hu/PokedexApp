import Foundation

class PokeAPIService {
    func fetchPokemonList(limit: Int, offset: Int, completion: @escaping (Result<PokemonList, Error>) -> Void) {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let pokemonList = try jsonDecoder.decode(PokemonList.self, from: data)
                    completion(.success(pokemonList))
                } catch {
                    completion(.failure(error))
                    print("Failed to decode: \(error.localizedDescription)")
                }
            } else if let error = error {
                completion(.failure(error))
                print("Error: \(error.localizedDescription)")
            }
        }.resume()
    }

    func fetchPokemonDetail(url: String, completion: @escaping (Result<Pokemon, Error>) -> Void) {
        guard let url = URL(string: url) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                    completion(.success(pokemon))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}
