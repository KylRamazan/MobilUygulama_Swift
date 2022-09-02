// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let denemeSinif = try? newJSONDecoder().decode(Kisiler.self, from: jsonData)

import Foundation

// MARK: - Kisiler
struct Kisiler: Codable {
    var users: [User]
    let success: Int
    let message: String
}

// MARK: - User
struct User: Codable {
    var userID, adSoyad, email, okulAdi: String
    var bolum, kullaniciAdi, sifre, egitim: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case adSoyad = "ad_soyad"
        case email
        case okulAdi = "okul_adi"
        case bolum
        case kullaniciAdi = "kullanici_adi"
        case sifre, egitim
    }
}
