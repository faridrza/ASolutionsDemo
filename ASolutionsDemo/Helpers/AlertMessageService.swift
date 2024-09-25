//
//  AlertMessageService.swift
//  ASolutionsDemo
//
//  Created by Farid Rzayev on 25.09.24.
//


import Foundation
import SwiftMessages

class AlertMessageService {
    
    // MARK: - Variables
    
    static let shared = AlertMessageService()
    
    // MARK: - Contructor
    
    private init() { }
    
    // MARK: - Functions
    
    @MainActor func showCardAlert(_ text: String, _ type: Theme, showButton: Bool, duration: SwiftMessages.Duration = .automatic) {
        let view: MessageView
        view = MessageView.viewFromNib(layout: .cardView)
        
        view.configureContent(title: .empty,
                              body: text,
                              iconImage: nil,
                              iconText: nil,
                              buttonImage: nil,
                              buttonTitle: "Done",
                              buttonTapHandler: { _ in SwiftMessages.hide() })
        
        let iconStyle: IconStyle
        iconStyle = .light
        view.configureTheme(type, iconStyle: iconStyle)
        view.titleLabel?.isHidden = true
        
        view.button?.isHidden = !showButton
        
        // Config setup
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .bottom
        config.duration = duration
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.shouldAutorotate = false
        config.interactiveHide = true

        // Show
        SwiftMessages.show(config: config, view: view)
    }
}

extension String {
    @MainActor func show(_ type: Theme, duration: SwiftMessages.Duration = .automatic) {
        AlertMessageService.shared.showCardAlert(self, type, showButton: true, duration: duration)
    }
}
