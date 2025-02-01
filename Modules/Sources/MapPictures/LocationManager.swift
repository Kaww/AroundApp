//
//  LocationManager.swift
//  Around
//
//  Created by KAWRANTIN on 01/02/2025.
//

import CoreLocation
import Observation

@Observable class LocationManager: NSObject, CLLocationManagerDelegate {
  private let locationManager = CLLocationManager()

  private(set) var location: CLLocationCoordinate2D = .paris

  override init() {
    super.init()
    locationManager.delegate = self
  }

  func requestLocation() {
    locationManager.requestWhenInUseAuthorization()
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    print("LocationManager authorizationStatus -> \(manager.authorizationStatus)")
    if manager.authorizationStatus != .denied {
      locationManager.requestLocation()
    }
  }
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print("LocationManager updated -> \(locations)")
    location = locations.first?.coordinate ?? .paris
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
    print("LocationManager Error -> \(error.localizedDescription)")
  }
}


extension CLLocationCoordinate2D {
  static let paris: Self = .init(latitude: 48.863777131154535, longitude: 2.3344758274435584)
  static let home: Self = .init(latitude: 48.83301946969535, longitude: 2.2378371167000943)
}

extension CLLocationCoordinate2D: @retroactive Equatable {
  public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    lhs.latitude == rhs.latitude
    && lhs.longitude == rhs.longitude
  }
}
