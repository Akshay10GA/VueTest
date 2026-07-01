# Aroma Roasters Mini-Store

A cross-platform e-commerce mini-store built with **Vue 3**, **Quasar v2**, and **Capacitor**. This single codebase compiles to a desktop web app, a native iOS app, and a native Android app.

## Web Development (Standard)

### Install the dependencies
```bash
npm install
```

### Start the app in development mode (HMR, error reporting, etc.)
```bash
npx quasar dev
```

### Build the web app for production
```bash
npx quasar build
```

---

## Native Mobile Development (Capacitor)

This project uses Capacitor to wrap the Vue web app into native iOS and Android applications.

### 🍎 iOS

**Prerequisites:** You must be on a macOS device with Xcode installed to compile iOS apps locally.

1. **Build the web assets and prepare iOS:**
   ```bash
   npx quasar build -m capacitor -T ios
   ```
2. **Open the project in Xcode:**
   ```bash
   cd src-capacitor
   npx cap open ios
   ```
   *(From Xcode, you can select a Simulator or physical device and click "Run").*

> **Note for Windows Users:** 
> Since you cannot run Xcode on Windows, we have configured a GitHub Actions workflow (`.github/workflows/main.yml`) that automatically builds an iOS Simulator `.app` bundle in the cloud on every push. You can download the generated `App.zip` artifact from the GitHub Actions tab on GitHub and preview it in your browser using [Appetize.io](https://appetize.io/).

### 🤖 Android

**Prerequisites:** You must have Android Studio and the Android SDK installed.

1. **Build the web assets and prepare Android:**
   ```bash
   npx quasar build -m capacitor -T android
   ```
2. **Open the project in Android Studio:**
   ```bash
   cd src-capacitor
   npx cap open android
   ```
   *(From Android Studio, you can run the app on a connected device or the Android Emulator).*

---

## Syncing Changes to Native

If you make changes to your Vue web code (`src/`), you need to build the assets and sync them into the native wrappers so the mobile apps reflect your changes:

```bash
# 1. Build the web assets for capacitor
npx quasar build -m capacitor

# 2. Sync the assets and plugins to iOS and Android
cd src-capacitor
npx cap sync
```

---

### Customizing Quasar Framework
See [Configuring quasar.config.ts](https://v2.quasar.dev/quasar-cli-vite/quasar-config-js) for advanced configuration.
