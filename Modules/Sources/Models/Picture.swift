//
//  Picture.swift
//  Around
//
//  Created by KAWRANTIN on 01/02/2025.
//

import UIKit

public struct Picture: Identifiable, Sendable, Equatable {
  public let location: PictureLocation
  public let image: UIImage
  public let text: String

  public let id: UUID

  public init(location: PictureLocation, image: UIImage, text: String) {
    self.location = location
    self.image = image
    self.text = text
    self.id = UUID()
  }

  public static func ==(lhs: Picture, rhs: Picture) -> Bool {
    lhs.id == rhs.id
  }
}

public extension Picture {

  static let mock = Picture(location: .paris, image: UIImage(resource: .eiffel), text: "Waaa this is the Eiffel Tower!\nAmazing!! 🎉")
  static let mockEmtpy = Picture(location: .home, image: UIImage(resource: .eiffel), text: "")

  static let famousPlaces = [
    Picture(
      location: PictureLocation(latitude: 48.8584, longitude: 2.2945),
      image: UIImage(resource: .eiffel),
      text: "Eiffel Tower"
    ),
    Picture(
      location: PictureLocation(latitude: 48.8606, longitude: 2.3376),
      image: UIImage(resource: .louvre),
      text: "Louvre Museum"
    ),
    Picture(
      location: PictureLocation(latitude: 48.8529, longitude: 2.3500),
      image: UIImage(resource: .notreDame),
      text: "Notre-Dame Cathedral"
    ),
    Picture(
      location: PictureLocation(latitude: 48.8566, longitude: 2.3522),
      image: UIImage(resource: .champs),
      text: "Champs-Élysées"
    ),
    Picture(
      location: PictureLocation(latitude: 48.8867, longitude: 2.3431),
      image: UIImage(resource: .sacreCoeur),
      text: "Sacré-Cœur Basilica"
    ),
    Picture(
      location: PictureLocation(latitude: 48.8600, longitude: 2.3266),
      image: UIImage(resource: .orsay),
      text: "Musée d'Orsay"
    ),
    Picture(
      location: PictureLocation(latitude: 48.8339, longitude: 2.3768),
      image: UIImage(resource: .bnf),
      text: "Bibliothèque nationale de France"
    ),
    Picture(
      location: PictureLocation(latitude: 48.8610, longitude: 2.3358),
      image: UIImage(resource: .palaisRoyal),
      text: "Palais Royal"
    ),
    Picture(
      location: PictureLocation(latitude: 48.8732, longitude: 2.3316),
      image: UIImage(resource: .opera),
      text: "Palais Garnier (Opera House)"
    ),
    Picture(
      location: PictureLocation(latitude: 48.8575, longitude: 2.3510),
      image: UIImage(resource: .pontNeuf),
      text: "Pont Neuf"
    )
  ]
}
