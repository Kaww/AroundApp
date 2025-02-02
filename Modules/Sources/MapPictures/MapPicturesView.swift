//
//  MapPicturesView.swift
//  Around
//
//  Created by KAWRANTIN on 01/02/2025.
//

import MapKit
import Models
import Pictures
import SwiftUI

public struct MapPicturesView: View {

  @State var locationManager = LocationManager()

  let pictures: [Picture] = [
    Picture(location: PictureLocation(latitude: 48.83301946969535, longitude: 2.2378371167000943), image: UIImage(), text: "")
  ]

  @Binding private var selection: Picture?
  @State private var position: MapCameraPosition = .camera(
    .init(centerCoordinate: .paris, distance: 50000)
  )

  @State private var isFlipped = false

  public init(
    viewingPicture: Binding<Picture?>
  ) {
    self._selection = viewingPicture
  }

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
    .overlay(alignment: .topTrailing) { profileButton }
    .overlay { pictureView }
    .ignoresSafeArea(.keyboard)
  }

  private var profileButton: some View {
    Button(action: {}) {
      Circle()
        .fill(.white)
        .shadow(color: .black.opacity(0.4), radius: 10)
        .overlay {
          Image.mockProfilePicture
            .resizable()
            .clipShape(Circle())
            .padding(4)
        }
        .frame(width: 58, height: 58)
        .padding()
    }
    .offset(x: selection == nil ? 0 : 100, y: selection == nil ? 0 : -100)
    .animation(.spring(duration: 0.3), value: selection)
  }

  private var pictureView: some View {
    ZStack {
      Color.black
        .ignoresSafeArea()
        .opacity(selection == nil ? 0 : 0.4)
        .onTapGesture {
          selection = nil
          isFlipped = false
        }
        .animation(.linear(duration: 0.1), value: selection)
      if let selection {
        PictureView(
          picture: selection,
          showPhotoInfos: true,
          isFlipped: isFlipped
        )
        .onTapGesture {
          isFlipped.toggle()
        }
        .onDisappear { isFlipped = false }
        .padding(.horizontal, 32)
        .transition(.opacity.combined(with: .scale(0.5)).combined(with: .move(edge: .bottom)))
      }
    }
    .animation(.spring(duration: 0.3), value: selection)
  }
}

private struct PreviewView: View {
  @State private var viewingPicture: Picture? = nil

  var body: some View {
    MapPicturesView(viewingPicture: $viewingPicture)
  }
}

#Preview {
  PreviewView()
}
