# NumGame

A minimal and elegant macOS puzzle game built with SwiftUI.

## Description
Solve procedurally generated algebraic grids that increase in difficulty as you progress. The goal is to fill in the missing numbers to satisfy all horizontal and vertical equations.

## Features
- **Infinite Levels**: Procedurally generated puzzles that get harder as you advance.
- **Minimalist UI**: Precise and clean design tailored for macOS.
- **Persistence**: Progress is automatically saved using `UserDefaults`.
- **Custom App Bundle**: Includes a build script to create a native `.app` with a high-quality emoji icon.

## How to Build
Run the provided compilation script:
```bash
chmod +x compile.sh
./compile.sh
```
Then open `NumGame.app`.
