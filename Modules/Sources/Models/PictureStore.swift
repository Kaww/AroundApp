//
//  PictureStore.swift
//  Around
//
//  Created by KAWRANTIN on 02/02/2025.
//

import SwiftUI

@Observable public final class PictureStore {
  public var pictures: [Picture]

  public init(pictures: [Picture]) {
    self.pictures = pictures
  }

  public func post(_ newPicture: Picture) {
    self.pictures.append(newPicture)
  }
}

//public extension EnvironmentValues {
//  @Entry var pictureStore: PictureStore = PictureStore(pictures: Picture.famousPlaces)
//}
