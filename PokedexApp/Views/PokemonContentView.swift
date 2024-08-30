import SwiftUI

struct PokemonContentView: View {
    @StateObject private var viewModel = PokemonViewModel()
    private let navigationTitle = "Pokedex"

    var body: some View {
        NavigationView {
            VStack {
                content
            }
            .navigationTitle(navigationTitle)
        }
    }

    // View content based on the state of the pokemon list
    @ViewBuilder
    private var content: some View {
        if viewModel.pokemonList.isEmpty && !viewModel.isLoading {
            loadingView
        } else {
            pokemonListView
        }

        if viewModel.isLoading {
            loadingIndicator
        }
    }

    // Loading view shown while fetching Pokémon
    private var loadingView: some View {
        ProgressView("Loading Pokémon...")
            .onAppear {
                viewModel.fetchPokemonList()
            }
    }

    // Main view displaying the Pokémon list with a scroll to top button
    private var pokemonListView: some View {
        ScrollViewReader { scrollViewProxy in
            ZStack(alignment: .bottomTrailing) {
                PokemonGridView(pokemonList: viewModel.pokemonList) {
                    viewModel.fetchPokemonList()
                }
                scrollToTopButton(scrollViewProxy: scrollViewProxy)
            }
        }
    }

    // Scroll to top button
    private func scrollToTopButton(scrollViewProxy: ScrollViewProxy) -> some View {
        Button(action: {
            withAnimation {
                scrollViewProxy.scrollTo("top", anchor: .top)
            }
        }) {
            Image(systemName: "arrow.up.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .padding()
                .foregroundColor(.black)
        }
        .background(Color.white)
        .clipShape(Circle())
        .shadow(radius: 5)
        .padding()
    }

    // Loading indicator shown at the bottom
    private var loadingIndicator: some View {
        ProgressView()
            .padding()
    }
}
