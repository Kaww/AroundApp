//
//  PictureLocation.swift
//  Around
//
//  Created by KAWRANTIN on 01/02/2025.
//

import Foundation
import MapKit

public struct PictureLocation: Sendable {
  public let latitude: Double
  public let longitude: Double
  public let coordinate: CLLocationCoordinate2D

  public init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
    self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }

  public init(from location: CLLocationCoordinate2D) {
    self.latitude = location.latitude
    self.longitude = location.longitude
    self.coordinate = location
  }
}

public extension PictureLocation {
  static let paris: Self = .init(latitude: 48.863777131154535, longitude: 2.3344758274435584)
  static let home: Self = .init(latitude: 48.83301946969535, longitude: 2.2378371167000943)

  public static func randomParisLocation() -> PictureLocation {
    // Paris rough boundaries
    let minLat = 48.815573 // Southernmost point
    let maxLat = 48.902145 // Northernmost point
    let minLong = 2.224199 // Westernmost point
    let maxLong = 2.469920 // Easternmost point

    // Generate random coordinates within Paris
    let randomLat = Double.random(in: minLat...maxLat)
    let randomLong = Double.random(in: minLong...maxLong)

    return PictureLocation(
      latitude: randomLat,
      longitude: randomLong
    )
  }
}
