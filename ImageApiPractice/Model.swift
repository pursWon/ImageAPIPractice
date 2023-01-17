import Foundation

struct Image: Decodable {
    let documents: [Contents]
}

struct Contents: Decodable {
    let image_url: String
}
