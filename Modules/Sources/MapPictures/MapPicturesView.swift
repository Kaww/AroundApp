//
//  MapPicturesView.swift
//  Around
//
//  Created by KAWRANTIN on 01/02/2025.
//

import MapKit
import Models
import SwiftUI

public struct MapPicturesView: View {

  @State var locationManager = LocationManager()

  let pictures: [Picture] = [
    Picture(location: PictureLocation(latitude: 48.83301946969535, longitude: 2.2378371167000943), image: UIImage(), text: "")
  ]

  @State private var selection: Picture?
  @State private var position: MapCameraPosition = .camera(
    .init(centerCoordinate: .paris, distance: 50000)
  )

  @State private var isFlipped = false

  public init() {}

  public var body: some View {
    Map(position: $position, bounds: MapCameraBounds(), interactionModes: [.pan, .zoom]) {
      ForEach(Picture.famousPlaces) { picture in
        Annotation(coordinate: picture.location.coordinate, anchor: .bottom) {
          Button {
            selection = picture
          } label: {
            VStack {
              Image(uiImage: picture.image)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            }
          }
        } label: {}
      }
    }
    .onAppear {
      locationManager.requestLocation()
    }
    .onChange(of: locationManager.location) { _, newValue in
      Task {
        try? await Task.sleep(for: .seconds(1))
        withAnimation {
          self.position = .camera(
            .init(centerCoordinate: newValue, distance: 5000)
          )
        }
      }
    }
    .mapStyle(.standard(elevation: .flat, emphasis: .automatic, pointsOfInterest: .excludingAll, showsTraffic: false))
    .onMapCameraChange(frequency: .onEnd, { context in
      print("Camera changed -> \(context.camera.centerCoordinate)")
    })
    .overlay {
      if let selection {
        ZStack {
          if isFlipped {
            Text(selection.text)
              .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
          } else {
            Image(uiImage: selection.image)
              .resizable()
              .scaledToFit()
              .frame(maxWidth: .infinity)
              .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
              .padding(10)
          }
        }
        .frame(width: 300, height: 400)
        .background(
          RoundedRectangle(cornerRadius: 5, style: .continuous)
            .fill(.white)
        )
        .onTapGesture { isFlipped.toggle() }
        .onDisappear { isFlipped = false }
        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0), perspective: 0.5)
        .animation(.spring, value: isFlipped)
        .overlay(alignment: .topTrailing) {
          Button(action: { self.selection = nil}) {
            Text("Close")
          }
        }
      }
    }
  }
}

#Preview {
  MapPicturesView()
}
