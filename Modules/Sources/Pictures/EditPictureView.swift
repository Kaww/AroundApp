//
//  EditPictureView.swift
//  Around
//
//  Created by KAWRANTIN on 02/02/2025.
//

import Models
import SwiftUI

public struct EditPictureView: View {
  @State private var editingText: String = ""
  @State private var isFlipped = false
  @FocusState private var isTextFieldFocused: Bool

  @State private var editingPicture: Picture
  private var onPublishTapped: (Picture) -> Void

  public init(
    picture: Picture,
  onPublishedTapped: @escaping (Picture) -> Void
  ) {
    self.editingPicture = picture
    self.onPublishTapped = onPublishedTapped
  }

  public var body: some View {
    NavigationStack {
      VStack {
        PictureView(
          picture: editingPicture,
          showPhotoInfos: false,
          isFlipped: isFlipped
        )
        .padding()
        .overlay {
          if isFlipped && editingPicture.text.isEmpty {
            Text("Tap to edit text")
              .font(.title)
              .foregroundStyle(.gray)
              .transition(.opacity.animation(.linear(duration: 0.2)))
          }
        }
        .onTapGesture {
          if isFlipped {
            isTextFieldFocused.toggle()
          }
        }

        flipButton

        TextField("...", text: $editingText, prompt: Text("123"))
          .focused($isTextFieldFocused)
          .multilineTextAlignment(.center)
          .opacity(0)

        Spacer()
      }
      .onChange(of: editingText, { oldValue, newValue in
        self.editingPicture = Picture(
          location: editingPicture.location,
          image: editingPicture.image,
          text: newValue
        )
      })
      .navigationTitle(Text("Your Picture"))
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button(action: { onPublishTapped(editingPicture) }) {
            Text("Post")
          }
        }
      }
      .ignoresSafeArea(.keyboard)
    }
  }

  private var flipButton: some View {
    Button(action: { isFlipped.toggle() }) {
      Text("Flip picture")
        .font(.system(size: 14, weight: .medium))
        .foregroundStyle(.white)
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(
          RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(Color.pink)
            .shadow(color: .pink.opacity(0.3), radius: 10)
        )
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  EditPictureView(picture: .mockEmtpy, onPublishedTapped: { _ in })
}
