# KipplePlugins

[![CI Status](https://github.com/bdrelling/KipplePlugins/actions/workflows/tests.yml/badge.svg)](https://github.com/bdrelling/KipplePlugins/actions/workflows/tests.yml)
[![Latest Release](https://img.shields.io/github/v/tag/bdrelling/KipplePlugins?color=blue&label=)](https://github.com/bdrelling/KipplePlugins/tags)
[![Swift Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbdrelling%2FKipplePlugins%2Fbadge%3Ftype%3Dswift-versions&label=)](https://swiftpackageindex.com/bdrelling/KipplePlugins)
[![Platform Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbdrelling%2FKipplePlugins%2Fbadge%3Ftype%3Dplatforms&label=)](https://swiftpackageindex.com/bdrelling/KipplePlugins)
[![License](https://img.shields.io/github/license/bdrelling/KipplePlugins?label=)](https://github.com/bdrelling/KipplePlugins/blob/main/LICENSE)

A collection of Swift Package Manager plugins.

> [!WARNING]
> The code in this library has been made public as-is solely for the purposes of reference, education, discovery, and personal use. As such, stability for production applications **CANNOT** be guaranteed; however, if you're interested in leveraging code within this library in your own projects, feel free to do so at your own risk.
>
> Please open GitHub issues for any problems you encounter or requests you have and we will do my best to provide support.

## To Do

### General

- [x] Include default configuration files (so repositories don't need their own) via `PluginSupport` module.
- [x] Allow repository to override the configuration file used with standard local dotfile for the applicable command.
- [] Add pre-commit installation scripts.
- [] Add `setup.sh` and other common script files to the project.

### Format

- [x] Add Format command (via SwiftFormat) as Swift Package and Xcode plugins.
- [x] Add functionality for formatting staged files only.

### Lint

- [] Add Lint command (via SwiftLint) as Swift Package and Xcode plugin.
- [] Add functionality for linting staged files only.

# Example Xcode Plugin

```swift
#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension FormatPlugin: XcodeCommandPlugin {
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        try self.perform(
            swiftformat: try context.tool(named: "swiftformat"),
            fileProvider: try context.tool(named: "kipple-file-provider"),
            // FIXME: This needs to detect the version somehow! Detect a .swift-version file, maybe?
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
```
