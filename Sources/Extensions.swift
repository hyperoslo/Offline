import Foundation

extension NSError {

  var isOffline: Bool {
    return Int32(code) == CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue
  }
}
