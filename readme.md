# NumGame

A minimal and elegant macOS puzzle game built with SwiftUI.

<img width="440" height="608" alt="Screenshot 2026-03-09 alle 01 44 33" src="https://github.com/user-attachments/assets/d822bfb5-b9b7-4763-b4a3-ff28151f25d6" />

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
