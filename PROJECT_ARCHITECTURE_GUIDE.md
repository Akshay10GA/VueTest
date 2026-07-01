# Project Architecture & Workflow Guide

This guide explains the architecture of the **Aroma Roasters** mini-store, detailing where your code lives, what each folder does, and how the underlying technologies communicate with each other.

---

## 1. How Vue, Quasar, and Capacitor Work Together

Your project is built using a modern "hybrid" stack. Instead of writing separate codebases for Web, iOS, and Android (using Swift, Kotlin, and React), you write **one single web codebase** that runs everywhere.

* **Vue.js 3:** The core JavaScript framework. This is what you use to write your actual application logic, manage state, and structure your HTML (`<template>`).
* **Quasar Framework (v2):** A UI library and build tool built *on top* of Vue. It provides all the ready-to-use Material Design components (like `<q-btn>`, `<q-dialog>`, and `<q-card>`) so you don't have to design them from scratch. It also provides the Quasar CLI (`quasar build`), which handles compiling your code.
* **Capacitor:** The "Native Bridge" created by Ionic. After Quasar turns your Vue code into standard HTML/CSS/JS web files, Capacitor takes those files and embeds them inside a native iOS or Android app wrapper. 

**The Magic of Capacitor:**
When a user opens your iOS app, they are actually opening a hidden, fullscreen Safari browser (a `WKWebView`) that runs your Vue website locally from the device's storage. Capacitor provides JavaScript APIs (like `@capacitor/app`) that allow your web code to securely "talk" to native device features like the Camera, GPS, or native push notifications.

---

## 2. Folder Structure: Where Does the Code Live?

You will spend **99% of your time** inside the `src/` directory. You almost never need to touch the root config files or the native iOS/Android folders unless you are adding native permissions.

### `src/` (Your Vue App)
This is the heart of your application where all your code lives.

* **`src/pages/`**: Contains the actual views of your app. Your app uses **file-based routing**, meaning the folder structure here dictates your URLs.
  * `index.vue` — This is the **Layout Wrapper** acting as a shell (Header, Sidebar Drawer).
  * `index/(index).vue` — This is the **Storefront Page** (coffee grid and cart) injected into the Layout.
* **`src/components/`**: Reusable "lego blocks" for your UI (e.g., `EssentialLink.vue`).
* **`src/css/`**: Global stylesheets (`app.scss`). However, Quasar relies heavily on utility classes, so custom CSS here is rare.
* **`src/router/`**: Controls how navigation works between pages.
* **`src/stores/`**: Uses **Pinia** for global state management (e.g., saving user's Cart data).
* **`src/boot/`**: Scripts that run *before* the Vue app officially starts (e.g., initializing Google Analytics).
* **`App.vue`**: The absolute root component of your Vue application.

### `src-capacitor/` (The Native Wrapper)
This folder holds the actual native iOS (Xcode) and Android (Android Studio) projects. 

* **`src-capacitor/www/`**: A hidden/ignored folder where Quasar dumps your compiled web code.
* **`src-capacitor/ios/`**: The native Xcode project used to build the iOS app.
* **`src-capacitor/android/`**: The native Android Studio project used to build the Android app.

### `.github/` (Automation)
* **`.github/workflows/main.yml`**: GitHub Actions pipeline script that automatically compiles the iOS app in the cloud whenever you push code.

---

## 3. Configuration Files Reference

Here is a quick overview of what each configuration file in the root directory does:

* **`quasar.config.ts`**: The master configuration file for the entire project, used to configure Vite, enable Quasar plugins, and configure build settings for Capacitor.
* **`package.json`**: Defines all the web dependencies (Vue, Quasar, Pinia) and scripts for your project.
* **`package-lock.json`**: Locks down the exact versions of all your npm dependencies to ensure consistent builds across machines.
* **`tsconfig.json`**: Configures how TypeScript interprets and checks your code.
* **`eslint.config.js`**: Rules for the ESLint linter to keep your JavaScript/TypeScript code clean and formatted consistently.
* **`postcss.config.js`**: Configures PostCSS tools (like Autoprefixer) which automatically add vendor prefixes to your CSS rules for cross-browser compatibility.
* **`.prettierrc.json`**: Rules for Prettier, an automatic code formatter that ensures a consistent code style across your team.
* **`index.html`**: The entry point HTML file where your Vue application is injected and mounted.
* **`env.d.ts`**: Provides TypeScript declarations for environment variables so TypeScript knows they exist.
* **`pnpm-workspace.yaml`**: Configuration for pnpm workspaces, allowing you to manage multiple packages within this single repository if needed.
* **`.editorconfig`**: Ensures consistent coding styles (like tabs vs spaces) between different IDEs and code editors.
* **`.gitignore`**: Tells Git which files and directories (like `node_modules` or build outputs) should NOT be tracked or uploaded to GitHub.
* **`README.md`**: The introduction file displayed on your GitHub repository page explaining what the project is.
