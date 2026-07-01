import Capacitor

extension CAPPluginCall {
    /// Temporary compatibility shim for plugin code calling `reject(_:)`.
    /// Routes reject to resolve with an error-shaped payload.
    func reject(_ message: String) {
        self.resolve(["success": false, "message": message])
    }
}