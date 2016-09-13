import Foundation

public final class RequestRestorer {

  public typealias Before = (NSMutableURLRequest, (NSURLRequest -> Void)) -> Void
  public typealias Completion = (NSURLRequest, NSURLResponse?, NSError?) -> Void

  public var before: Before = { request, completion in completion(request) }
  public var running = false

  let networking: Networking

  // MARK: - Initialization

  public init(networking: Networking) {
    self.networking = networking
  }

  // MARK: - Replay

  public func replay(completion: Completion? = nil) {
    let requests = RequestStorage.shared.requests

    guard !running && requests.count > 0 else {
      return
    }

    running = true

    var count = requests.count

    for request in requests.values {
      guard let mutableRequest = request.mutableCopy() as? NSMutableURLRequest else {
        continue
      }

      before(mutableRequest) { [weak self] request in
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
