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
//    RoundedRectangle(cornerRadius: 16, style: .continuous)
//      .fill(.gray)
    Image.kodakSkin
      .resizable()
      .overlay {
        cameraEye
      }
      .overlay(alignment: .bottomTrailing) {
        closeButton
      }
      .overlay {
        captureButton
      }
      .overlay(alignment: .top) {
        grabIndicator
      }
      .padding(20)
      .drawingGroup()
      .scaleEffect(isCameraPresented ? 1 : 0.8, anchor: .top)
      .offset(y: isCameraPresented ? 0 : availableSize.height - 30)
      .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isCameraPresented)
  }

  private var cameraEye: some View {
    GeometryReader { proxy in
      if let currentCameraFrame = CGImage.blackImage {//(camera.currentCameraFrame ?? .blackImage) {
        Image(decorative: currentCameraFrame, scale: 1)
          .resizable()
          .scaledToFill()
          .aspectRatio(57/83, contentMode: .fit)
          .frame(width: 80)
          .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
          .offset(
            x: proxy.size.width * 0.68,
            y: proxy.size.height * 0.38
          )
      }
    }
  }

  private var closeButton: some View {
    GeometryReader { proxy in
      Button(action: {
        isCameraPresented = false
        Task {
          //        camera.stopCapture()
        }
      }) {
        Image(systemName: "xmark.circle.fill")
          .resizable()
          .frame(width: 36, height: 36)
          .foregroundStyle(.red)
          .background(Circle().fill(.white))
      }
      .buttonStyle(.plain)
      .offset(
        x: proxy.size.width * 0.8,
        y: proxy.size.height * 0.92
      )
    }
  }

  private var captureButton: some View {
    GeometryReader { proxy in
      Button(action: { self.capturedPicture = .blackImage /*camera.currentCameraFrame*/ }) {
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
      .offset(
        x: proxy.size.width * 0.1,
        y: proxy.size.height * 0.8
      )
    }
  }

  private var grabIndicator: some View {
    GeometryReader { proxy in
      Button(action: {
        isCameraPresented = true
        Task {
          //        await camera.startCapture()
        }
      }) {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
          .fill(Color(cgColor: .init(red: 34/255, green: 24/255, blue: 24/255, alpha: 1)))
          .frame(width: 80, height: 40)
          .overlay {
            Image(systemName: "chevron.up")
              .font(.system(size: 24, weight: .bold))
              .foregroundStyle(.white)
          }
      }
      .buttonStyle(.plain)
      .offset(
        x: proxy.size.width * 0.48 - 80/2,
        y: -proxy.size.height * 0.01
      )
    }
  }
}

#Preview {
  CameraView(didChoosePhoto: { _ in })
}
