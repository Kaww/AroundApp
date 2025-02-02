//
//  BaseAppView.swift
//  Around
//
//  Created by KAWRANTIN on 01/02/2025.
//

import Camera
import MapPictures
import SwiftUI

public struct BaseAppView: View {

  public init() {}

  public var body: some View {
    MapPicturesView()
      .overlay {
        CameraView()
      }
  }
}

#Preview {
  BaseAppView()
}
