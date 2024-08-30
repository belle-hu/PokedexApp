import SwiftUI

struct PokemonGridView: View {
    let pokemonList: [PokemonEntry]
    let loadMoreAction: () -> Void

    private let columns = [GridItem(.adaptive(minimum: 120))]

    var body: some View {
        ScrollView {
            topAnchorView
            pokemonGrid
        }
    }

    // Top anchor view for scroll-to-top functionality
    private var topAnchorView: some View {
        Color.clear
            .frame(height: 0)
            .id("top")
    }

    // Grid displaying Pokémon entries
    private var pokemonGrid: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            pokemonGridItems
            if shouldLoadMore {
                loadingIndicator
            }
        }
        .padding()
    }

    // Pokémon items in the grid
    private var pokemonGridItems: some View {
        ForEach(pokemonList, id: \.name) { pokemon in
            NavigationLink(destination: PokemonDetailView(pokemonURL: pokemon.url)) {
                PokemonGridItemView(pokemon: pokemon)
            }
        }
    }

    // Determine if more data should be loaded
    private var shouldLoadMore: Bool {
        !pokemonList.isEmpty
    }

    // Loading indicator displayed when reaching the bottom of the grid
    private var loadingIndicator: some View {
        ProgressView()
            .onAppear(perform: loadMoreAction)
            .padding()
    }
}

struct PokemonGridItemView: View {
    let pokemon: PokemonEntry
    @State private var imageUrl: URL?
    @State private var image: UIImage? = nil

    var body: some View {
        VStack {
            pokemonImage
            pokemonName
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 1)
        )
    }

    // Display Pokémon image or a loading indicator
    private var pokemonImage: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
            } else {
                ProgressView()
                    .frame(width: 80, height: 80)
                    .onAppear(perform: fetchPokemonImage)
            }
        }
    }

    // Display Pokémon name
    private var pokemonName: some View {
        Text(pokemon.name.capitalized)
            .font(.headline)
            .lineLimit(1)
            .truncationMode(.tail)
            .padding(10)
            .frame(maxWidth: .infinity)
    }

    // Fetch Pokémon image from the URL
    private func fetchPokemonImage() {
        if let cachedImage = ImageCache.shared.object(forKey: pokemon.name as NSString) {
            self.image = cachedImage
        } else {
            loadPokemonDetails()
        }
    }

    // Load Pokémon details and fetch the image
    private func loadPokemonDetails() {
        guard let url = URL(string: pokemon.url) else {
            print("Invalid Pokémon URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print("Failed to load Pokémon details: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            decodePokemonDetails(from: data)
        }.resume()
    }

    // Decode Pokémon details to extract the image URL
    private func decodePokemonDetails(from data: Data) {
        do {
            let pokemonDetail = try JSONDecoder().decode(Pokemon.self, from: data)
            guard let imageUrlString = pokemonDetail.sprites.front_default,
                  let imageUrl = URL(string: imageUrlString) else {
                print("Invalid image URL")
                return
            }

            fetchImage(from: imageUrl)
        } catch {
            print("Failed to decode Pokémon details: \(error.localizedDescription)")
        }
    }

    // Fetch the image from the URL
    private func fetchImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let imageData = data, let downloadedImage = UIImage(data: imageData) else {
                print("Failed to load image data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            DispatchQueue.main.async {
                print("Image downloaded successfully")
                ImageCache.shared.setObject(downloadedImage, forKey: pokemon.name as NSString)
                self.image = downloadedImage
            }
        }.resume()
    }
}
