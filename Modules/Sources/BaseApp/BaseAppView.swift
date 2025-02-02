//
//  BaseAppView.swift
//  Around
//
//  Created by KAWRANTIN on 01/02/2025.
//

import Camera
import MapPictures
import Models
import SwiftUI

public struct BaseAppView: View {

  @State private var editingPicture: Picture?

  public init() {}

  public var body: some View {
    MapPicturesView()
      .overlay {
        CameraView(didChoosePhoto: { photo in
          editingPicture = Picture(
            location: .home, // TODO: add real location
            image: UIImage(cgImage: photo),
            text: ""
          )
        })
      }
      .sheet(item: $editingPicture) { picture in
        Text(picture.text)
      }
  }
}

#Preview {
  BaseAppView()
}
