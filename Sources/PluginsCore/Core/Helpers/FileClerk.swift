// Copyright © 2022 Brian Drelling. All rights reserved.

import Foundation

public class FileClerk {
    // MARK: - Shared Instance

    public static let shared = FileClerk()

    // MARK: - Properties

    public private(set) var configurationFiles: [ConfigurationFile] = []

    private init() {
        self.configurationFiles = ConfigurationTool.allCases.flatMap(self.bundledConfigurationFiles)
    }

    private func bundledConfigurationFiles(for tool: ConfigurationTool) -> [ConfigurationFile] {
        Bundle.module.paths(forResourcesOfType: tool.fileExtension, inDirectory: nil).compactMap { path in
            if let name = path.split(separator: "/").last?.replacingOccurrences(of: ".\(tool.fileExtension)", with: "") {
                return ConfigurationFile(tool, name: name, path: path)
            } else {
                return nil
            }
        }
    }
}
