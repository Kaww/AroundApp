//
//  CameraCapture.swift
//  Around
//
//  Created by KAWRANTIN on 01/02/2025.
//

import AVFoundation
import CoreImage
import Foundation

/// Gracefully stolen from `https://developer.apple.com/tutorials/sample-apps/capturingphotos-camerapreview`
@Observable final class CameraCapture: NSObject {

  private var captureSession = AVCaptureSession()
  private var deviceInput: AVCaptureDeviceInput?
  private var sessionQueue = DispatchQueue(label: "session queue")
  private var videoOutput: AVCaptureVideoDataOutput?

  private let frameQueue = DispatchQueue(label: "frame.queue")
  private var _currentCameraFrame: CGImage?
  public var currentCameraFrame: CGImage? {
    get {
      _currentCameraFrame
//      frameQueue.sync { _currentCameraFrame }
    }
    set {
      _currentCameraFrame = newValue
//      frameQueue.sync { _currentCameraFrame = newValue }
    }
  }

  private var isCaptureStarted: Bool = false

  private func setFrontCameraMirrored(videoOutput: AVCaptureVideoDataOutput, captureDevice: AVCaptureDevice) {
    if let videoOutputConnection = videoOutput.connection(with: .video) {
      if videoOutputConnection.isVideoMirroringSupported {
        videoOutputConnection.isVideoMirrored = captureDevice.position == .front
      }
    }
  }

  @MainActor private func checkAuthorization() async -> Bool {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      return true

    case .notDetermined:
      sessionQueue.suspend()
      let status = await AVCaptureDevice.requestAccess(for: .video)
      sessionQueue.resume()
      return status

    case .denied, .restricted:
      return false

    @unknown default:
      return false
    }
  }

  @MainActor func startCapture() async {
    guard !self.isCaptureStarted else { return }
    // DEVICE conf.
    guard
      let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
      let deviceInput = try? AVCaptureDeviceInput(device: captureDevice)
    else {
      print("CameraCapture -> Failed to obtain video input for device.")
      return
    }

    // SESSION conf.
    let captureSession = AVCaptureSession()
    self.captureSession = captureSession
    self.captureSession.beginConfiguration()

    captureSession.sessionPreset = AVCaptureSession.Preset.photo

    // OUTPUT
    let videoOutput = AVCaptureVideoDataOutput()
    videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoDataOutputQueue"))
    guard captureSession.canAddOutput(videoOutput) else {
      print("CameraCapture -> Can't add output.")
      return
    }
    captureSession.addOutput(videoOutput)
    self.videoOutput = videoOutput

    // INPUT
    guard captureSession.canAddInput(deviceInput) else {
      print("CameraCapture -> Can't add input.")
      return
    }
    captureSession.addInput(deviceInput)
    self.deviceInput = deviceInput

    // START
    let authorized = await self.checkAuthorization()
    guard authorized else {
      print("CameraCapture -> Camera access is not authorized.")
      return
    }

    self.captureSession.commitConfiguration()

    self.isCaptureStarted = true
    print("CameraCapture -> STARTED")

    sessionQueue.async {
      self.captureSession.startRunning()
    }
  }

  func stopCapture() {
    sessionQueue.async { [weak self] in
      guard let self else { return }
      self.captureSession.beginConfiguration()
      if let input = self.deviceInput {
        captureSession.removeInput(input)
        deviceInput = nil
      }
      if let output = self.videoOutput {
        captureSession.removeOutput(output)
        videoOutput = nil
      }
      self.captureSession.commitConfiguration()
      self.captureSession.stopRunning()
      self.currentCameraFrame = nil
      self.isCaptureStarted = false
      print("CameraCapture -> STOPPED")
    }
  }
}

extension CameraCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(
    _ output: AVCaptureOutput,
    didOutput sampleBuffer: CMSampleBuffer,
    from connection: AVCaptureConnection
  ) {
    guard let pixelBuffer = sampleBuffer.imageBuffer else { return }

    connection.videoOrientation = .portrait

    let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
    let ciContext = CIContext()
    self.currentCameraFrame = ciContext.createCGImage(ciImage, from: ciImage.extent)
  }
}

extension CGImage {
  static var blackImage: CGImage? {
    let width = 57
    let height = 83
    let bytesPerPixel = 4
    let bytesPerRow = width * bytesPerPixel
    let bitsPerComponent = 8
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue

    guard let context = CGContext(
      data: nil,
      width: width,
      height: height,
      bitsPerComponent: bitsPerComponent,
      bytesPerRow: bytesPerRow,
      space: colorSpace,
      bitmapInfo: bitmapInfo
    ) else {
      return nil
    }

    context.setFillColor(CGColor(red: 0, green: 0, blue: 0, alpha: 1))
    context.fill(CGRect(x: 0, y: 0, width: width, height: height))

    return context.makeImage()
  }
}
