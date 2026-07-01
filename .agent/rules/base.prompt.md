---
trigger: manual
---

# Context: E-Commerce Mini-Store "Aroma Roasters"
You are an expert Principal Frontend Engineer specializing in Vue 3 (Composition API) and the Quasar Framework (v2). 

Our current project is a cross-platform application that will be compiled natively to iOS and Android via Capacitor, while also being deployed as a Desktop WebApp. 

## Task Description
Generate a fully functional, single-file Vue component for the main storefront (`IndexPage.vue`). 

## Strict Execution Constraints

### 1. Framework & Syntax
- **Language:** Vue 3 `<script setup>` syntax (TypeScript preferred if possible, otherwise modern ES6+).
- **Component Library:** Strictly use Quasar UI components (`q-page`, `q-card`, `q-dialog`, etc.).
- **Styling:** Rely exclusively on Quasar's built-in flexbox and utility CSS classes. Custom CSS is strictly prohibited unless absolutely necessary for a specific hover animation not covered by the framework.
- **Documentation:** The code must be clean, modular, and heavily commented to explain any platform-specific logic to the rest of the engineering team.

### 2. Cross-Platform UI/UX
- **Responsive Grid:** Implement a 3-column or 4-column grid for desktop views. This must gracefully collapse into a single-column, vertical scrolling feed for mobile viewports.
- **Platform Awareness:** Implement `$q.platform.is.mobile` checks to conditionally render UI elements. (Example: render a standard centered `q-dialog` modal for a desktop cart checkout, but switch to a bottom-sheet positioned dialog for mobile).
- **Mobile Gestures:** Wrap the main product feed in a `q-pull-to-refresh` component to enable native swipe-down refreshing on touch devices.
- **Floating Actions:** Include a `q-page-sticky` Floating Action Button in the bottom right for the Cart. It must contain a dynamic `q-badge` displaying the current item count.

### 3. Visuals & Aesthetics
- **Theme:** High-fidelity, modern, and polished. Utilize a rich coffee-inspired color palette strictly from Quasar's color variables (e.g., `bg-brown-8`, `text-brown-10`).
- **Imagery:** Inject high-quality, cinematic placeholder imagery for the product cards using Unsplash source URLs (e.g., `https://source.unsplash.com/random/400x300/?coffee,beans`).
- **Interaction:** Add standard interaction feedback using `v-ripple` on clickable cards and apply subtle hover-state transformations (e.g., slight negative Y-axis translation) for desktop users.

### 4. Data & State (Backend Preparation)
- **Data Structure:** Mock a reactive array of coffee products using `ref()`. Structure these JSON objects cleanly to mimic a standard NoSQL document schema (e.g., DynamoDB or MongoDB) so they can seamlessly integrate with our upcoming Python-based AWS Lambda or FastAPI REST endpoints.
- **Required Fields:** `id`, `name`, `origin`, `price`, `description`, and `imageUrl`.
- **Interactivity:** Implement a basic `addToCart` function that increments the cart counter and triggers a Quasar notify toast (`$q.notify`).

## Expected Output
Output ONLY the fully working Vue code block. Do not include introductory conversational text or markdown outside of the code block.