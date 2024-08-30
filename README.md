# Pokedex App

## Implemented Behaviors

### Milestone 1

1. Implemented a Pokedex app that fetches a list of Pokémon and displays them in a grid.
2. Implemented functionality so that tapping on a Pokémon displays it in the top center of the screen.

### Milestone 2

- Added pagination so that the app doesn’t load all the Pokémon at once.

### Milestone 3

- Implemented caching by storing temporary data in memory.

## Product & Technical Choices

I implemented caching through temporary in-memory caching because it’s fast, though the tradeoff is that it’s non-persistent. The caching is done by storing images in an `NSCache` object, which automatically manages memory and removes items as needed. Here’s why I chose this approach:

- **Efficiency**: In a simple app that displays details about Pokémon, the data that needs to be cached is typically small. Pokémon images and details don't consume a lot of memory, so in-memory caching seemed like a good fit.
- **Speed**: When a user scrolls through the list of Pokémon, in-memory caching allows the app to display images and data instantaneously, without the delay associated with fetching data from disk or re-downloading from the network.

Additionally, I implemented a "back-to-the-top" button to improve the user experience. During testing, I noticed that after scrolling down a long list of Pokémon, it can be tedious to manually scroll back up.

On the UI side, I decided to display all the Pokémon in a two-column grid instead of loading more onto the page for the following reasons:

1. Displaying too many Pokémon at once could be overwhelming for the user.
2. It’s more readable when each row has fewer Pokémon, allowing the text to be fully displayed without truncation or the need for ellipses.

## Next Steps

- **Persistent Caching**: I'd want to find a more persistent caching approach so that images are retained across app sessions.
- **Glitch Fixes**: There is currently an issue where the "back-to-the-top" button occasionally glitches when scrolling down. I suspect this may be related to pagination. Perhaps when new items are added to the `ScrollView`, it triggers a re-render or layout update, affecting the stability of elements like the scroll-to-top button.
