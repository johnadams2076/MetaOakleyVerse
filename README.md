# MetaOakleyVision

## What this is
iOS app for Meta/Oakley/Meta AI glasses that captures a user-initiated photo, sends it to an AI backend, displays a description, and speaks it back.

## Current status
MVP target is iOS mock photo flow.

## Why Codespaces alone cannot compile iOS
Codespaces is used for editing. iOS compilation and simulator tests run on GitHub Actions macOS runners.

## How to run backend
```bash
cd backend
cp .env.example .env
export MOCK_AI=true
uvicorn app.main:app --host 0.0.0.0 --port 8787 --reload
```

## How to run backend tests
```bash
cd backend
MOCK_AI=true pytest -q
```

## How to generate iOS project (macOS only)
```bash
cd ios
brew install xcodegen
xcodegen generate
```

## How GitHub Actions works
- `backend-tests.yml` runs backend pytest in Ubuntu.
- `ios-build.yml` generates the Xcode project with XcodeGen and builds/tests on macOS.
- `ios-mock-visual-test.yml` runs simulator UI tests in mock mode and uploads screenshot/video artifacts.

## How to view mock visual results
Go to GitHub Actions -> iOS Mock Visual Test -> latest run -> Artifacts -> download `ios-mock-visual-results`.

## How to test real glasses later
Use TestFlight or local Mac install on a real iPhone, pair glasses, enable DAT setup, and switch app to real glasses mode.

## Privacy
No background recording, no API keys in app, and no upload without explicit capture.
