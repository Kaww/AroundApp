//
//  CapturedPictureView.swift
//  Around
//
//  Created by KAWRANTIN on 02/02/2025.
//

import Models
import SwiftUI

struct CapturedPictureView: View {
//  @Namespace private var profileName
  @Binding var capturedPicture: CGImage?
  let availableSize: CGSize

  var body: some View {
    ZStack {
      Color.white.opacity(capturedPicture == nil ? 0 : 0.5)
        .animation(.linear(duration: 0.3))

      slidingPhotoView
    }
    .animation(.spring(duration: 0.3), value: capturedPicture)
  }

  private var slidingPhotoView: some View {
    ZStack {
      if let capturedPicture {
        Image(decorative: capturedPicture, scale: 1)
          .resizable()
          .scaledToFill()
          .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
          .transition(.opacity)
      } else {
        Rectangle()
          .fill(.white)
          .transition(.opacity)
      }
    }
    .aspectRatio(57/83, contentMode: .fit)
    .frame(width: 300, height: 300)
    .drawingGroup()
    .scaleEffect(capturedPicture == nil ? 0.5 : 1)
    .rotationEffect(.degrees(capturedPicture == nil ? -20 : 5))
    .offset(x: capturedPicture == nil ? -availableSize.width : 0)
    .background {
      ZStack {
        retryButton
          .offset(y: -190)
          .opacity(capturedPicture == nil ? 0 : 1)
          .scaleEffect(capturedPicture == nil ? 0.5 : 1)
          .animation(.spring(response: 0.3, dampingFraction: 0.6).delay(0.1), value: capturedPicture)

        validateButton
          .offset(y: 190)
          .opacity(capturedPicture == nil ? 0 : 1)
          .scaleEffect(capturedPicture == nil ? 0.5 : 1)
          .animation(.spring(response: 0.3, dampingFraction: 0.6).delay(0.2), value: capturedPicture)
      }
    }
  }

  private var retryButton: some View {
    Button(action: { capturedPicture = nil }) {
      Circle()
        .fill(Color.yellow)
        .frame(width: 50, height: 50)
        .overlay {
          Image(systemName: "arrow.counterclockwise")
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(.white)
        }
        .rotationEffect(.degrees(90))
    }
    .buttonStyle(.plain)
  }

  private var validateButton: some View {
    Button(action: {}) {
      Circle()
        .fill(Color.green)
        .frame(width: 50, height: 50)
        .overlay {
          Image(systemName: "checkmark")
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(.white)
        }
        .rotationEffect(.degrees(90))
    }
    .buttonStyle(.plain)
  }
}

private struct PreviewView: View {
  @State private var cgImage = Picture.famousPlaces.first?.image.cgImage
  @State private var capturedPicture: CGImage?

  var body: some View {
    GeometryReader { proxy in
      ZStack {
        Button(action: { capturedPicture = cgImage }) {
          VStack(spacing: 48) {
            Text("Take Picture!   Take Picture!")
            Text("Take Picture!   Take Picture!")
            Text("Take Picture!   Take Picture!")
            Text("Take Picture!   Take Picture!")
            Text("Take Picture!   Take Picture!")
            Text("Take Picture!   Take Picture!")
          }
          .font(.title)
        }

        CapturedPictureView(capturedPicture: $capturedPicture, availableSize: proxy.size)
      }
    }
  }
}

#Preview {
  PreviewView()
}
