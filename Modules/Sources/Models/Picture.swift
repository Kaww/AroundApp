//
//  Picture.swift
//  Around
//
//  Created by KAWRANTIN on 01/02/2025.
//

import UIKit

public struct Picture {
  public let location: PictureLocation
  public let image: UIImage
  public let text: String

  public init(location: PictureLocation, image: UIImage, text: String) {
    self.location = location
    self.image = image
    self.text = text
  }
}
