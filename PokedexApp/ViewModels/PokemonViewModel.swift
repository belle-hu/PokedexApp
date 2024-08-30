import Foundation
import Combine

class PokemonViewModel: ObservableObject {
    @Published var pokemonList: [PokemonEntry] = []
    @Published var isLoading: Bool = false
    private var service = PokeAPIService()
    private var currentOffset: Int = 0
    private var canLoadMore: Bool = true

    func fetchPokemonList() {
        guard !isLoading && canLoadMore else { return }

        isLoading = true
        service.fetchPokemonList(limit: 20, offset: currentOffset) { result in
            switch result {
            case .success(let pokemonList):
                DispatchQueue.main.async {
                    self.pokemonList.append(contentsOf: pokemonList.results)
                    self.currentOffset += 20
                    self.canLoadMore = pokemonList.results.count == 20 // Only if 20 items were fetched, assume more pages are available.
                    self.isLoading = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    print(error.localizedDescription)
                }
            }
        }
    }
}
