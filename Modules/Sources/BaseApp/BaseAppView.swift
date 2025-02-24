//
//  BaseAppView.swift
//  Around
//
//  Created by KAWRANTIN on 01/02/2025.
//

import Camera
import CoreLocation
import MapPictures
import Models
import Pictures
import SwiftUI

public struct BaseAppView: View {

  @State var pictureStore: PictureStore = PictureStore(pictures: Picture.famousPlaces)

  @State private var mapViewingPicture: Picture?

  @State private var editingPicture: Picture?

  public init() {}

  public var body: some View {
    MapPicturesView(
      pictureStore: pictureStore,
      viewingPicture: $mapViewingPicture
    )
    .overlay {
      CameraView(didChoosePhoto: { photo in
        editingPicture = Picture(
          location: .randomParisLocation(),
          image: UIImage(cgImage: photo),
          text: ""
        )
      })
      .offset(y: mapViewingPicture == nil ? 0 : 80)
      .animation(.spring(duration: 0.2), value: mapViewingPicture)
    }
    .sheet(item: $editingPicture) { picture in
      EditPictureView(picture: picture, onPublishedTapped: { newPicture in
        pictureStore.post(newPicture)
        editingPicture = nil
      })
    }
  }
}

#Preview {
  BaseAppView()
}
