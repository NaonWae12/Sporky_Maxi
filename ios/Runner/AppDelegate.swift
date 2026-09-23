import Flutter
import Photos
import UIKit
import UniformTypeIdentifiers

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate, UIDocumentInteractionControllerDelegate {
  private let shareChannel = "sporky_maxi/share_moment"
  private var documentInteractionController: UIDocumentInteractionController?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    if let controller = window?.rootViewController as? FlutterViewController {
      configureShareChannel(messenger: controller.binaryMessenger)
    }
    return result
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "ShareMomentPlugin") {
      configureShareChannel(messenger: registrar.messenger())
    }
  }

  private func configureShareChannel(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: shareChannel, binaryMessenger: messenger)
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { return }

      switch call.method {
      case "shareImage":
        guard
          let args = call.arguments as? [String: Any],
          let path = args["path"] as? String,
          let target = args["target"] as? String
        else {
          result(FlutterError(code: "INVALID_ARGS", message: "Image path and target are required.", details: nil))
          return
        }
        self.shareImage(path: path, target: target, result: result)
      case "saveToGallery":
        guard
          let args = call.arguments as? [String: Any],
          let path = args["path"] as? String
        else {
          result(FlutterError(code: "INVALID_ARGS", message: "Image path is required.", details: nil))
          return
        }
        self.saveImageToGallery(path: path, result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func shareImage(path: String, target: String, result: @escaping FlutterResult) {
    let fileURL = URL(fileURLWithPath: path)
    guard FileManager.default.fileExists(atPath: fileURL.path) else {
      result(FlutterError(code: "SHARE_FAILED", message: "Image file does not exist.", details: nil))
      return
    }

    let scheme: String
    let uti: String
    switch target {
    case "whatsapp":
      scheme = "whatsapp://"
      uti = "net.whatsapp.image"
    case "instagram":
      scheme = "instagram://app"
      if #available(iOS 14.0, *) {
        uti = UTType.image.identifier
      } else {
        uti = "public.image"
      }
    default:
      result(FlutterError(code: "INVALID_ARGS", message: "Unsupported share target.", details: nil))
      return
    }

    guard let appURL = URL(string: scheme), UIApplication.shared.canOpenURL(appURL) else {
      result(FlutterError(code: "APP_NOT_FOUND", message: "Target app is not installed.", details: nil))
      return
    }

    let controller = UIDocumentInteractionController(url: fileURL)
    controller.delegate = self
    controller.uti = uti
    documentInteractionController = controller

    guard let presenter = topViewController() else {
      result(FlutterError(code: "SHARE_FAILED", message: "Cannot find presenter.", details: nil))
      return
    }

    let opened = controller.presentOpenInMenu(
      from: CGRect(x: presenter.view.bounds.midX, y: presenter.view.bounds.maxY - 1, width: 1, height: 1),
      in: presenter.view,
      animated: true
    )
    if opened {
      result(nil)
    } else {
      result(FlutterError(code: "SHARE_FAILED", message: "Cannot open share target.", details: nil))
    }
  }

  private func saveImageToGallery(path: String, result: @escaping FlutterResult) {
    let fileURL = URL(fileURLWithPath: path)
    guard FileManager.default.fileExists(atPath: fileURL.path) else {
      result(FlutterError(code: "SAVE_FAILED", message: "Image file does not exist.", details: nil))
      return
    }

    let saveChanges = {
      PHPhotoLibrary.shared().performChanges({
        let request = PHAssetCreationRequest.forAsset()
        request.addResource(with: .photo, fileURL: fileURL, options: nil)
      }) { success, error in
        DispatchQueue.main.async {
          if success {
            result(nil)
          } else {
            result(FlutterError(code: "SAVE_FAILED", message: error?.localizedDescription, details: nil))
          }
        }
      }
    }

    if #available(iOS 14.0, *) {
      let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
      if status == .authorized || status == .limited {
        saveChanges()
        return
      }
      PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
        if newStatus == .authorized || newStatus == .limited {
          saveChanges()
        } else {
          DispatchQueue.main.async {
            result(FlutterError(code: "SAVE_FAILED", message: "Photo library access denied.", details: nil))
          }
        }
      }
      return
    }

    let status = PHPhotoLibrary.authorizationStatus()
    if status == .authorized {
      saveChanges()
      return
    }
    PHPhotoLibrary.requestAuthorization { newStatus in
      if newStatus == .authorized {
        saveChanges()
      } else {
        DispatchQueue.main.async {
          result(FlutterError(code: "SAVE_FAILED", message: "Photo library access denied.", details: nil))
        }
      }
    }
  }

  private func topViewController() -> UIViewController? {
    var controller = window?.rootViewController
    while let presented = controller?.presentedViewController {
      controller = presented
    }
    return controller
  }
}
