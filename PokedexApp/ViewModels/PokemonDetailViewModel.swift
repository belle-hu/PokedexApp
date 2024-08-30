import Foundation
import Combine

class PokemonDetailViewModel: ObservableObject {
    @Published var pokemon: Pokemon?
    private var service = PokeAPIService()

    func fetchPokemonDetail(pokemonURL: String) {
        service.fetchPokemonDetail(url: pokemonURL) { result in
            switch result {
            case .success(let pokemon):
                DispatchQueue.main.async {
                    self.pokemon = pokemon
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
