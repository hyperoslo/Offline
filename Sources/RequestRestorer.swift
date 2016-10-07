import Foundation

public final class RequestRestorer {

  public typealias Before = (inout URLRequest, ((URLRequest) -> Void)) -> Void
  public typealias Completion = (URLRequest, URLResponse?, NSError?) -> Void

  public var before: Before = { request, completion in completion(request) }
  public var running = false

  let networking: Networking

  // MARK: - Initialization

  public init(networking: Networking) {
    self.networking = networking
  }

  // MARK: - Replay

  public func replay(_ completion: Completion? = nil) {
    let requests = RequestStorage.shared.requests

    guard !running && requests.count > 0 else {
      return
    }

    running = true

    var count = requests.count

    for var request in requests.values {
      before(&request) { [weak self] request in
        self?.networking.send(request) { [weak self] data, response, error in
          if error?.isOffline != true {
            RequestStorage.shared.remove(request)
          }

          completion?(request, response, error)
          count -= 1

          if count == 0 {
            self?.running = false
          }
        }
      }
    }
  }
}
