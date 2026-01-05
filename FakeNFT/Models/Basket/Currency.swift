struct Currency: Decodable {
    let title: String
    let name: String
    let imageName: String
    
    private enum CodingKeys: String, CodingKey {
        case title
        case name
        case imageName = "image"
    }
}
