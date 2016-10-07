import Foundation

public final class RequestStorage {
  let key = "Offline.RequestStorage"

  public static let shared: RequestStorage = RequestStorage()

  public fileprivate(set) var requests = [String: URLRequest]()

  fileprivate var userDefaults: UserDefaults {
    return UserDefaults.standard
  }

  // MARK: - Initialization

  init() {
    requests = load()
  }

  // MARK: - Save

  public func save(_ request: URLRequest) {
    guard let key = request.url?.absoluteString else {
      return
    }

    requests[key] = request
    saveAll()
  }

  public func saveAll() {
    let data = NSKeyedArchiver.archivedData(withRootObject: requests)
    userDefaults.set(data, forKey: key)
    userDefaults.synchronize()
  }

  // MARK: - Remove

  public func remove(_ request: URLRequest) {
    guard let key = request.url?.absoluteString else {
      return
    }

    requests.removeValue(forKey: key)
    saveAll()
  }

  public func clear() {
    requests.removeAll()
    userDefaults.removeObject(forKey: key)
    userDefaults.synchronize()
  }

  // MARK: - Load

  func load() -> [String: URLRequest] {
    guard let data = userDefaults.object(forKey: key) as? Data,
      let dictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: URLRequest]
      else { return [:] }

    return dictionary
  }
}
