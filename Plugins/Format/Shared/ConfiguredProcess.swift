// Copyright © 2022 Brian Drelling. All rights reserved.

import Foundation

// TODO: Find a way to include this file across all plugins, in lieu of dependency support.
struct ConfiguredProcess {
    private let process = Process()
    private let outputPipe = Pipe()

    
    
    
    
    init(
        executablePath: String,
        arguments: [String]? = nil,
        environment: [String: String]? = nil,
        workingDirectory: String? = nil
    ) {
        // Set the executable path for the process.
        self.process.executableURL = URL(fileURLWithPath: executablePath)

        // Set arguments for the process.
        self.process.arguments = arguments

        // Load environment variables into the process.
        self.process.environment = environment

        // Set the working directory for the process.
        if let workingDirectory = workingDirectory {
            self.process.currentDirectoryURL = URL(fileURLWithPath: workingDirectory, isDirectory: true)
        }

        // Set the pipe for stdout
        self.process.standardOutput = self.outputPipe
    }

    @discardableResult
    func run() throws -> String {
        // Run the process.
        try self.process.run()

        // Create variables for our stdout and stderr data.
        let outputData: Data

        // Read the stdout, and stderr data.
        if #available(macOS 10.15.4, *) {
            outputData = try self.outputPipe.fileHandleForReading.readToEnd() ?? Data()
        } else {
            outputData = self.outputPipe.fileHandleForReading.readDataToEndOfFile()
        }

        // Convert data to strings.
        let output = String(data: outputData, encoding: .utf8)

        // If there's no output, throw an error
        // Successful commands should still return empty output, so treat this as a command failure as well
        guard let unwrappedOutput = output else {
            throw ProcessError.outputNotFound
        }

        return unwrappedOutput
    }
}

// MARK: - Supporting Types

enum ProcessError: Error {
    case outputNotFound
}

// MARK: - Convenience

extension ConfiguredProcess {
    static func bash(
        command: String,
        environment: [String: String]? = nil,
        workingDirectory: String? = nil
    ) -> ConfiguredProcess {
        .init(
            executablePath: "/bin/bash",
            arguments: ["-c", command]
        )
    }
}
