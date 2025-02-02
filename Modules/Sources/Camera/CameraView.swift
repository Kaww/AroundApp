//
//  CameraView.swift
//  Around
//
//  Created by KAWRANTIN on 01/02/2025.
//

import SwiftUI

public struct CameraView: View {

  @State private var camera = CameraCapture()
  @State private var capturedPicture: CGImage?

  @State private var isHidden: Bool = true

  public init() {}

  public var body: some View {
    GeometryReader { proxy in
      ZStack {
        cameraView(availableSize: proxy.size)

        CapturedPictureView(
          capturedPicture: $capturedPicture,
          availableSize: proxy.size
        )
      }
//        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: capturedPicture)
    }
  }

  private func cameraView(availableSize: CGSize) -> some View {
    RoundedRectangle(cornerRadius: 16, style: .continuous)
      .fill(.gray)
      .overlay {
        cameraEye
      }
      .overlay(alignment: .bottomTrailing) {
        closeButton
      }
      .overlay(alignment: .bottomLeading) {
        captureButton
      }
      .overlay(alignment: .top) {
        grabIndicator
      }
      .padding(20)
      .drawingGroup()
      .offset(y: isHidden ? availableSize.height - 30 : 0)
      .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isHidden)
  }

  private var cameraEye: some View {
    HStack {
      Spacer()
      if let currentCameraFrame = (camera.currentCameraFrame ?? .blackImage) {
        Image(decorative: currentCameraFrame, scale: 1)
          .resizable()
          .scaledToFill()
          .aspectRatio(57/83, contentMode: .fit)
          .frame(width: 80)
          .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
      }
    }
    .padding()
  }

  private var closeButton: some View {
    Button(action: {
      isHidden = true
      Task {
        camera.stopCapture()
      }
    }) {
      Image(systemName: "xmark.circle.fill")
        .resizable()
        .frame(width: 36, height: 36)
        .foregroundStyle(.red)
        .background(Circle().fill(.white))
    }
    .buttonStyle(.plain)
    .padding()
  }

  private var captureButton: some View {
    Button(action: { self.capturedPicture = camera.currentCameraFrame }) {
      Circle()
        .fill(.white)
        .overlay {
          Circle()
            .stroke(lineWidth: 3)
            .padding(8)
        }
        .frame(width: 80, height: 80)
    }
    .buttonStyle(.plain)
    .padding()
  }

  private var grabIndicator: some View {
    Button(action: {
      isHidden = false
      Task {
        await camera.startCapture()
      }
    }) {
      RoundedRectangle(cornerRadius: 8, style: .continuous)
        .fill(.gray)
        .frame(width: 80, height: 40)
        .overlay {
          Image(systemName: "chevron.up")
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(.white)
        }
    }
    .buttonStyle(.plain)
    .offset(y: -20)
  }
}

#Preview {
  CameraView()
}
