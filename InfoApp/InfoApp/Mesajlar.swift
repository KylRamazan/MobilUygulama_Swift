// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mesajlar = try? newJSONDecoder().decode(Mesajlar.self, from: jsonData)

import Foundation

// MARK: - Mesajlar
struct Mesajlar: Codable {
    let messages: [Messages]
    let success: Int
    let message: String
}

// MARK: - Message
struct Messages: Codable {
    let messageID, gondericiID, aliciID, mesajText: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case messageID = "message_id"
        case gondericiID = "gonderici_id"
        case aliciID = "alici_id"
        case mesajText = "mesaj_text"
        case status
    }
}

