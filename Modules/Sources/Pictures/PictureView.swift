//
//  PictureView.swift
//  Around
//
//  Created by KAWRANTIN on 02/02/2025.
//

import Models
import SwiftUI

public struct PictureView: View {
  let picture: Picture
  let showPhotoInfos: Bool
  let isFlipped: Bool

  private let likeCount = Int.random(in: 0...200)

  public init(
    picture: Picture,
    showPhotoInfos: Bool,
    isFlipped: Bool
  ) {
    self.picture = picture
    self.showPhotoInfos = showPhotoInfos
    self.isFlipped = isFlipped
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: 4, style: .continuous)
      .fill(.white)
      .aspectRatio(8/10, contentMode: .fit)
      .shadow(color: .black.opacity(0.1), radius: 20)
      .overlay {
        ZStack {
          frontView
            .opacity(isFlipped ? 0 : 1)

          backView
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0), perspective: 0)
            .opacity(isFlipped ? 1 : 0)
        }
      }
      .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0), perspective: 0.5)
      .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isFlipped)
  }

  private var frontView: some View {
    GeometryReader { proxy in
      Color.clear
        .overlay(alignment: .top) {
          Image(uiImage: picture.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(
              width: proxy.size.width * 0.95,
              height: proxy.size.width * 0.95
            )
            .clipShape(
              RoundedRectangle(cornerRadius: 2, style: .continuous)
            )
            .padding(.top, proxy.size.width * 0.025)
        }
        .overlay(alignment: .bottom) {
          frontPhotoInfosView
            .padding([.horizontal, .bottom], proxy.size.width * 0.025)
            .frame(height: proxy.size.height - proxy.size.width)
            .padding(.horizontal)
        }
    }
  }

  private var frontPhotoInfosView: some View {
    HStack {
      HStack {
        Image.mockProfilePicture
          .resizable()
          .frame(width: 32, height: 32)
          .clipShape(Circle())
          .shadow(color: .black.opacity(0.2), radius: 8)
        VStack(alignment: .leading) {
          Text("Taytay")
            .font(.system(size: 12, weight: .medium))
          HStack(spacing: 2) {
            Image(systemName: "clock.fill")
              .font(.system(size: 8, weight: .bold))
            Text(showPhotoInfos ? "8h32min" : "-")
              .font(.system(size: 10, weight: .medium))
          }
          .foregroundStyle(.gray)
        }
      }

      Spacer()

      VStack(spacing: 0) {
        Image(systemName: "heart.fill")
          .renderingMode(.template)
          .foregroundStyle(LinearGradient(colors: [.pink, .red], startPoint: .topTrailing, endPoint: .bottomTrailing))
          .opacity(0.9)
          .shadow(color: .pink.opacity(0.4), radius: 10)
          .font(.system(size: 28))
        Text(showPhotoInfos ? "\(likeCount)" : "-")
          .font(.system(size: 12, weight: .medium))
      }
    }
  }

  private var backView: some View {
    Text(picture.text)
      .padding(.horizontal, 32)
      .multilineTextAlignment(.center)
  }
}

private struct PreviewView: View {
  @State private var isFlipped: Bool = false

  var body: some View {
    PictureView(
      picture: .mock,
      showPhotoInfos: true,
      isFlipped: isFlipped
    )
    .padding()
    .onTapGesture {
      isFlipped.toggle()
    }
  }
}

#Preview {
  PreviewView()
}
