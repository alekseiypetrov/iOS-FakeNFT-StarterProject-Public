struct Currency: Decodable {
    let id: String
    let title: String
    let name: String
    let imageName: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case name
        case imageName = "image"
    }
}
