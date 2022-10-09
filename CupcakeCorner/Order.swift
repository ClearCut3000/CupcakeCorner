//
//  Order.swift
//  CupcakeCorner
//
//  Created by Николай Никитин on 08.10.2022.
//

import SwiftUI

class Order: ObservableObject, Codable {

  //MARK: - Properties
  static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

  @Published var type = 0
  @Published var quantity = 3
  @Published var specialRequestEnabled = false {
    didSet {
      if specialRequestEnabled == false {
        extraFrosting = false
        addSprinkles = false
      }
    }
  }
  @Published var extraFrosting = false
  @Published var addSprinkles = false

  @Published var name = ""
  var nameIsValid: Bool {
    if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      return false
    }
    return true
  }

  @Published var streetAddress = ""
  var streetAddressIsValid: Bool {
    if streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      return false
    }
    return true
  }

  @Published var city = ""
  var cityIsValid: Bool {
    guard !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
    return city.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil
  }

  @Published var zip = ""
  var zipIsValid: Bool {
    guard !zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
    return CharacterSet(charactersIn: zip).isSubset(of: CharacterSet.decimalDigits)
  }

  var hasValidAddress: Bool {
    if nameIsValid || streetAddressIsValid || cityIsValid || zipIsValid {
      return false
    }
    return true
  }

  var cost: Double {
    var cost = Double(quantity) * 2

    cost += (Double(type) / 2)

    if extraFrosting {
      cost += Double(quantity)
    }
    if addSprinkles {
      cost += Double(quantity) / 2
    }
    return cost
  }

  //MARK: - Codable
  enum CodingKeys: CodingKey {
    case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(type, forKey: .type)
    try container.encode(quantity, forKey: .quantity)
    try container.encode(extraFrosting, forKey: .extraFrosting)
    try container.encode(addSprinkles, forKey: .addSprinkles)
    try container.encode(name, forKey: .name)
    try container.encode(streetAddress, forKey: .streetAddress)
    try container.encode(city, forKey: .city)
    try container.encode(zip, forKey: .zip)
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    type = try container.decode(Int.self, forKey: .type)
    quantity = try container.decode(Int.self, forKey: .quantity)
    extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
    addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
    name = try container.decode(String.self, forKey: .name)
    streetAddress = try container.decode(String.self, forKey: .streetAddress)
    city = try container.decode(String.self, forKey: .city)
    zip = try container.decode(String.self, forKey: .zip)
  }

  //MARK: - Init
  init() { }
}
