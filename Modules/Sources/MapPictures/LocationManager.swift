//
//  LocationManager.swift
//  Around
//
//  Created by KAWRANTIN on 01/02/2025.
//

import CoreLocation
import Models
import Observation

@Observable public class LocationManager: NSObject, CLLocationManagerDelegate {
  private let locationManager = CLLocationManager()

  public private(set) var location: CLLocationCoordinate2D = .paris

  override public init() {
    super.init()
    locationManager.delegate = self
  }

  func requestLocation() {
    locationManager.requestWhenInUseAuthorization()
  }

  public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    print("LocationManager authorizationStatus -> \(manager.authorizationStatus)")
    if manager.authorizationStatus != .denied {
      locationManager.requestLocation()
    }
  }
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print("LocationManager updated -> \(locations)")
    location = locations.first?.coordinate ?? .paris
  }

  public func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
    print("LocationManager Error -> \(error.localizedDescription)")
  }
}

extension CLLocationCoordinate2D: @retroactive Equatable {
  public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    lhs.latitude == rhs.latitude
    && lhs.longitude == rhs.longitude
  }
}
