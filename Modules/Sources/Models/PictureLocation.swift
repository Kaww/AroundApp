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
}
