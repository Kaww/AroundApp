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
  @State private var isCameraPresented: Bool = false

  let didChoosePhoto: (CGImage) -> Void

  public init(didChoosePhoto: @escaping (CGImage) -> Void) {
    self.didChoosePhoto = didChoosePhoto
  }

  public var body: some View {
    GeometryReader { proxy in
      ZStack {
        cameraView(availableSize: proxy.size)

        CapturedPictureView(
          capturedPicture: $capturedPicture,
          availableSize: proxy.size,
          didChoosePhoto: {
            if let photo = capturedPicture {
              Task {
                capturedPicture = nil
                try? await Task.sleep(for: .seconds(0.2))
                isCameraPresented = false
                try? await Task.sleep(for: .seconds(0.4))
                didChoosePhoto(photo)
              }
            }
          }
        )
      }
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
      .scaleEffect(isCameraPresented ? 1 : 0.8, anchor: .top)
      .offset(y: isCameraPresented ? 0 : availableSize.height - 30)
      .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isCameraPresented)
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
      isCameraPresented = false
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
      isCameraPresented = true
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
  CameraView(didChoosePhoto: { _ in })
}
