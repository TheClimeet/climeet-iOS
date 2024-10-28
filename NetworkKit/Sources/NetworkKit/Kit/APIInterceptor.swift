public protocol TokenRefreshable: Sendable {
    func refreshToken() async -> Bool
}
