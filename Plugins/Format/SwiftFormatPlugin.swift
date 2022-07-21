// Copyright © 2022 Brian Drelling. All rights reserved.

import Foundation
import PackagePlugin

@main
struct SwiftFormatPlugin {
    private func perform(
        swiftformat: PluginContext.Tool,
        defaultSwiftVersion: String,
        defaultConfigurationFile: String,
        arguments: [String],
        targetPaths: ([String]) throws -> [String]
    ) throws {
        var extractor = ArgumentExtractor(arguments)

        let swiftVersion = extractor.option(named: "swiftversion", defaultValue: defaultSwiftVersion)
        let configurationFile = extractor.option(named: "config", defaultValue: defaultConfigurationFile)

        let shouldLogVerbosely = extractor.flag(named: "verbose")

        let targetNames = extractor.extractOption(named: "target")
        let targets = try targetPaths(targetNames)

        let executableURL = URL(fileURLWithPath: swiftformat.path.string)

        if shouldLogVerbosely {
            print("------------------------------------------------------------")
            print("DEBUG INFO")
            print("------------------------------------------------------------")
            print("=> Executable Path:     \(executableURL.path)")
            print("=> Swift Version:       \(swiftVersion)")
            print("=> Configuration File:  \(configurationFile)")
            print("=> Verbose?:            \(shouldLogVerbosely)")
            print("=> Targets:             \(targets)")
            print("=> Arguments:           \(arguments)")
            print("------------------------------------------------------------")
        }

        // Each set of arguments is an array, which is flattened into a single String array before passing into the Process.
        var arguments = [
            // First, include all files that should be formatted.
            !targets.isEmpty ? targets : ["."],
            ["--swiftversion", swiftVersion],
            ["--config", configurationFile],
            // SwiftFormat caches outside of the package directory, which is inaccessible to this package, so we cannot cache results.
            // TODO: Investigate alternative directory or system of caching, or open SwiftFormat issue to address?
            ["--cache", "ignore"],
            extractor.remainingArguments,
        ]

        if shouldLogVerbosely {
            arguments.append(["--verbose"])
        }

        let process = Process()
        process.executableURL = executableURL
        process.arguments = arguments.flatMap { $0 }

        let outputPipe = Pipe()
        process.standardOutput = outputPipe

        try process.run()
        process.waitUntilExit()
    }
}

extension ArgumentExtractor {
    mutating func option(named argument: String) -> String? {
        self.extractOption(named: argument).first
    }

    mutating func option(named argument: String, defaultValue: String) -> String {
        self.option(named: argument) ?? defaultValue
    }

    mutating func options(named argument: String) -> [String] {
        self.extractOption(named: argument)
    }

    mutating func option(named argument: String, defaultValues: [String]) -> [String] {
        let options = self.options(named: argument)

        // If options are empty, return the defaultValues array instead.
        return !options.isEmpty ? options : defaultValues
    }

    mutating func flag(named argument: String) -> Bool {
        // The Int value represents the number of occurrences of the flag.
        // Since we won't ever have a use for passing a flag multiple times, we'll just evaluate as a Bool.
        self.extractFlag(named: argument) > 0
    }
}

enum ArgumentExtractionError: Error {
    case argumentNotFound(String)
}

extension SwiftFormatPlugin: CommandPlugin {
    func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {
        let defaultConfigurationFile = context.package.directory.appending("Sources/PluginsCore/Resources/default.swiftformat").string

        let toolsVersion = context.package.toolsVersion
        let swiftVersion = "\(toolsVersion.major).\(toolsVersion.minor).\(toolsVersion.patch)"

        try self.perform(
            swiftformat: try context.tool(named: "swiftformat"),
            defaultSwiftVersion: swiftVersion,
            defaultConfigurationFile: defaultConfigurationFile,
            arguments: arguments
        ) { targets in
            try context.package.targets(named: targets).map(\.directory.string)
        }
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftFormatPlugin: XcodeCommandPlugin {
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        try self.perform(
            swiftformat: try context.tool(named: "swiftformat"),
            defaultSwiftVersion: "5.7",
            arguments: arguments
        ) { targetNames in
            // It is impossible to provide directories like in Swift Package case
            // because input files in XcodeTarget aren't restricted by a directory.
            let targets = context.xcodeProject.targets.filter { targetNames.contains($0.displayName) }
            return targets.flatMap(\.inputFiles).map(\.path.string)
        }
    }
}
#endif
