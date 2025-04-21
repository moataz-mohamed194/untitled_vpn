//
//  PacketTunnelProvider.swift
//  VPNExtension
//
//  Created by moataz mohamed on 21/04/2025.
//

import NetworkExtension
import OpenVPNAdapter

class PacketTunnelProvider: NEPacketTunnelProvider {
    private var vpnAdapter: OpenVPNAdapter?
    private var startHandler: ((Error?) -> Void)?
    
    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        startHandler = completionHandler
        
        // Initialize OpenVPN adapter
        vpnAdapter = OpenVPNAdapter()
        vpnAdapter?.delegate = self
        
        // Start VPN connection
        do {
            let config = try OpenVPNConfiguration()
            config.fileContent = "" // Your OpenVPN configuration will be set here
            
            let properties = try vpnAdapter?.apply(configuration: config)
            try vpnAdapter?.connect(using: packetFlow)
        } catch {
            completionHandler(error)
        }
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        vpnAdapter?.disconnect()
        completionHandler()
    }
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        guard let message = String(data: messageData, encoding: .utf8) else {
            completionHandler?(nil)
            return
        }
        
        // Handle different message types
        switch message {
        case "status":
            let status = vpnAdapter?.status.rawValue ?? 0
            completionHandler?(Data([UInt8(status)]))
        default:
            completionHandler?(nil)
        }
    }
    
    override func sleep(completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    override func wake() {
        // Handle wake from sleep
    }
}

extension PacketTunnelProvider: OpenVPNAdapterDelegate {
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, configureTunnelWithNetworkSettings networkSettings: NEPacketTunnelNetworkSettings?, completionHandler: @escaping (Error?) -> Void) {
        guard let settings = networkSettings else {
            completionHandler(nil)
            return
        }
        
        setTunnelNetworkSettings(settings) { error in
            completionHandler(error)
        }
    }
    
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleEvent event: OpenVPNAdapterEvent, message: String?) {
        switch event {
        case .connected:
            startHandler?(nil)
            startHandler = nil
        case .disconnected:
            break
        case .reconnecting:
            break
        case .error:
            startHandler?(NSError(domain: "VPNError", code: 1, userInfo: [NSLocalizedDescriptionKey: message ?? "Unknown error"]))
            startHandler = nil
        @unknown default:
            break
        }
    }
    
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleError error: Error) {
        startHandler?(error)
        startHandler = nil
    }
}
