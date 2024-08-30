import SwiftUI

struct PokemonDetailView: View {
    @StateObject private var viewModel = PokemonDetailViewModel()
    let pokemonURL: String

    var body: some View {
        VStack {
            content
            Spacer()
        }
        .padding()
        .navigationTitle("Pokemon Detail")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchPokemonDetail(pokemonURL: pokemonURL)
        }
    }

    // Main content based on whether the Pokémon data is available
    @ViewBuilder
    private var content: some View {
        if let pokemon = viewModel.pokemon {
            pokemonDetail(pokemon: pokemon)
        } else {
            loadingView
        }
    }

    // View displaying Pokémon details
    private func pokemonDetail(pokemon: Pokemon) -> some View {
        VStack(spacing: 4) {
            pokemonImage(url: pokemon.sprites.front_default)
            pokemonName(name: pokemon.name)
        }
    }

    // Loading view shown while fetching Pokémon details
    private var loadingView: some View {
        ProgressView("Loading...")
            .frame(height: 200)
    }

    // View for displaying the Pokémon image
    private func pokemonImage(url: String?) -> some View {
        AsyncImage(url: URL(string: url ?? ""), scale: 0.5) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(height: 200)
        } placeholder: {
            ProgressView()
                .frame(height: 200)
        }
    }

    // View for displaying the Pokémon name
    private func pokemonName(name: String) -> some View {
        Text(name.capitalized)
            .font(.largeTitle)
    }
}
