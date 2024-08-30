import Foundation

struct Pokemon: Codable, Identifiable {
    let id: Int
    let name: String
    let sprites: Sprites
}

struct Sprites: Codable {
    let front_default: String?
}

