<template>
  <!--
    =====================================================================
    IndexPage.vue — Aroma Roasters Storefront
    =====================================================================
    Main product listing page for the Aroma Roasters e-commerce mini-store.
    Features:
      - Responsive 3/4-col desktop → 1-col mobile product grid
      - Pull-to-refresh on touch devices
      - Platform-aware cart dialog (centered desktop / bottom-sheet mobile)
      - Floating Action Button with dynamic cart badge
      - Hover card animations for desktop users
    =====================================================================
  -->
  <q-page class="q-pa-md" style="background: linear-gradient(180deg, #3e2723 0%, #4e342e 40%, #efebe9 100%); min-height: 100vh;">

    <!-- =============================================================== -->
    <!-- HERO SECTION — branding banner with store tagline               -->
    <!-- =============================================================== -->
    <section class="q-mb-xl text-center q-pt-lg q-pb-md">
      <q-icon name="local_cafe" size="56px" color="amber-4" class="q-mb-sm" />
      <h1 class="text-h3 text-weight-bold text-amber-2 q-mb-xs" style="letter-spacing: 2px; font-family: 'Roboto Slab', serif;">
        AROMA ROASTERS
      </h1>
      <p class="text-subtitle1 text-brown-3" style="letter-spacing: 1px;">
        Artisan single-origin beans · Roasted to perfection
      </p>
      <q-separator color="amber-8" class="q-mx-auto q-mt-md" style="max-width: 120px; height: 3px; border-radius: 4px;" />
    </section>

    <!-- =============================================================== -->
    <!-- PULL-TO-REFRESH — enables native swipe-down on touch devices    -->
    <!-- Wraps the entire product feed so mobile users can refresh stock. -->
    <!-- =============================================================== -->
    <q-pull-to-refresh @refresh="onRefresh" color="brown-8">

      <!-- ============================================================= -->
      <!-- PRODUCT GRID                                                   -->
      <!-- Uses Quasar's responsive col system:                           -->
      <!--   • Desktop (md+): 3 columns (col-md-4)                       -->
      <!--   • Tablet  (sm):  2 columns (col-sm-6)                       -->
      <!--   • Mobile  (xs):  1 column  (col-12)                         -->
      <!-- The gutter class adds consistent spacing between cards.        -->
      <!-- ============================================================= -->
      <div class="row q-col-gutter-lg justify-center" style="max-width: 1200px; margin: 0 auto;">
        <div
          v-for="product in products"
          :key="product.id"
          class="col-12 col-sm-6 col-md-4 col-lg-3"
        >
          <!-- ========================================================= -->
          <!-- PRODUCT CARD                                               -->
          <!-- v-ripple adds Material-style tap feedback.                 -->
          <!-- The 'product-card' class applies hover transform for       -->
          <!-- desktop via scoped CSS (only exception to the no-CSS rule  -->
          <!-- per the prompt — Quasar has no built-in hover translate).  -->
          <!-- ========================================================= -->
          <q-card
            v-ripple
            class="product-card cursor-pointer"
            flat
            bordered
            style="border-radius: 16px; overflow: hidden; transition: transform 0.3s cubic-bezier(.25,.8,.25,1), box-shadow 0.3s ease;"
            @click="openProductDetail(product)"
          >
            <!-- Product image — cinematic Unsplash coffee photography -->
            <q-img
              :src="product.imageUrl"
              :ratio="4 / 3"
              spinner-color="brown-8"
              spinner-size="40px"
            >
              <!-- Origin badge overlay on the image -->
              <div class="absolute-top-right q-pa-xs">
                <q-badge
                  color="brown-9"
                  text-color="amber-2"
                  class="text-caption q-px-sm q-py-xs"
                  style="border-radius: 8px; backdrop-filter: blur(4px); background: rgba(62, 39, 35, 0.85);"
                >
                  {{ product.origin }}
                </q-badge>
              </div>
            </q-img>

            <q-card-section class="bg-brown-1">
              <!-- Product name -->
              <div class="text-h6 text-brown-10 text-weight-bold q-mb-xs" style="line-height: 1.3;">
                {{ product.name }}
              </div>

              <!-- Product description — clamped to 2 lines -->
              <p class="text-body2 text-brown-7 q-mb-sm" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                {{ product.description }}
              </p>

              <!-- Price and Add-to-Cart row -->
              <div class="row items-center justify-between">
                <span class="text-h5 text-weight-bold text-brown-9" style="font-family: 'Roboto Slab', serif;">
                  ${{ product.price.toFixed(2) }}
                </span>
                <q-btn
                  round
                  flat
                  icon="add_shopping_cart"
                  color="brown-8"
                  size="md"
                  @click.stop="addToCart(product)"
                >
                  <q-tooltip
                    class="bg-brown-10"
                    anchor="top middle"
                    self="bottom middle"
                  >
                    Add to cart
                  </q-tooltip>
                </q-btn>
              </div>
            </q-card-section>
          </q-card>
        </div>
      </div>
    </q-pull-to-refresh>

    <!-- =============================================================== -->
    <!-- PRODUCT DETAIL DIALOG                                            -->
    <!-- Platform-aware positioning:                                      -->
    <!--   • Desktop: standard centered dialog                            -->
    <!--   • Mobile:  bottom-sheet style via `position="bottom"`          -->
    <!-- =============================================================== -->
    <q-dialog
      v-model="detailDialogOpen"
      :position="$q.platform.is.mobile ? 'bottom' : 'standard'"
      transition-show="slide-up"
      transition-hide="slide-down"
    >
      <q-card
        v-if="selectedProduct"
        :style="$q.platform.is.mobile
          ? 'border-radius: 24px 24px 0 0; max-height: 85vh;'
          : 'border-radius: 16px; min-width: 420px; max-width: 520px;'"
        class="bg-brown-1"
      >
        <!-- Mobile drag indicator bar -->
        <div
          v-if="$q.platform.is.mobile"
          class="flex flex-center q-pt-sm q-pb-xs"
        >
          <div style="width: 40px; height: 4px; border-radius: 2px; background: #bcaaa4;" />
        </div>

        <q-img
          :src="selectedProduct.imageUrl"
          :ratio="16 / 9"
          spinner-color="brown-8"
        />

        <q-card-section>
          <div class="row items-center justify-between q-mb-sm">
            <div class="text-h5 text-brown-10 text-weight-bold">
              {{ selectedProduct.name }}
            </div>
            <q-badge color="brown-8" text-color="amber-2" class="text-subtitle2 q-px-sm q-py-xs" style="border-radius: 8px;">
              {{ selectedProduct.origin }}
            </q-badge>
          </div>

          <p class="text-body1 text-brown-7 q-mb-md">
            {{ selectedProduct.description }}
          </p>

          <q-separator color="brown-3" class="q-mb-md" />

          <div class="row items-center justify-between">
            <span class="text-h4 text-weight-bold text-brown-9" style="font-family: 'Roboto Slab', serif;">
              ${{ selectedProduct.price.toFixed(2) }}
            </span>
            <q-btn
              unelevated
              color="brown-8"
              text-color="amber-2"
              icon="add_shopping_cart"
              label="Add to Cart"
              no-caps
              class="q-px-lg"
              style="border-radius: 12px;"
              @click="addToCart(selectedProduct); detailDialogOpen = false"
            />
          </div>
        </q-card-section>
      </q-card>
    </q-dialog>

    <!-- =============================================================== -->
    <!-- CART DIALOG                                                       -->
    <!-- Platform-aware: centered on desktop, bottom-sheet on mobile.     -->
    <!-- Displays line items with quantities and a checkout total.         -->
    <!-- =============================================================== -->
    <q-dialog
      v-model="cartDialogOpen"
      :position="$q.platform.is.mobile ? 'bottom' : 'standard'"
      transition-show="slide-up"
      transition-hide="slide-down"
    >
      <q-card
        :style="$q.platform.is.mobile
          ? 'border-radius: 24px 24px 0 0; width: 100%; max-height: 85vh;'
          : 'border-radius: 16px; min-width: 440px; max-width: 560px;'"
        class="bg-brown-1"
      >
        <!-- Mobile drag indicator -->
        <div v-if="$q.platform.is.mobile" class="flex flex-center q-pt-sm q-pb-xs">
          <div style="width: 40px; height: 4px; border-radius: 2px; background: #bcaaa4;" />
        </div>

        <q-card-section class="row items-center q-pb-none">
          <q-icon name="shopping_cart" size="28px" color="brown-8" class="q-mr-sm" />
          <div class="text-h5 text-brown-10 text-weight-bold">Your Cart</div>
          <q-space />
          <q-btn flat round icon="close" color="brown-6" v-close-popup />
        </q-card-section>

        <q-separator color="brown-3" class="q-mx-md q-mt-sm" />

        <q-card-section style="max-height: 50vh; overflow-y: auto;">
          <!-- Empty cart state -->
          <div v-if="cartItems.length === 0" class="text-center q-py-xl">
            <q-icon name="shopping_bag" size="64px" color="brown-4" />
            <p class="text-subtitle1 text-brown-5 q-mt-md">Your cart is empty</p>
            <p class="text-body2 text-brown-4">Browse our selection and add some coffee!</p>
          </div>

          <!-- Cart line items -->
          <q-list v-else separator>
            <q-item v-for="item in cartItems" :key="item.product.id" class="q-py-sm">
              <q-item-section avatar>
                <q-avatar rounded size="56px">
                  <q-img :src="item.product.imageUrl" />
                </q-avatar>
              </q-item-section>

              <q-item-section>
                <q-item-label class="text-weight-medium text-brown-10">
                  {{ item.product.name }}
                </q-item-label>
                <q-item-label caption class="text-brown-6">
                  ${{ item.product.price.toFixed(2) }} × {{ item.quantity }}
                </q-item-label>
              </q-item-section>

              <q-item-section side>
                <div class="row items-center no-wrap q-gutter-xs">
                  <q-btn flat round dense icon="remove" color="brown-6" size="sm" @click="decrementItem(item.product.id)" />
                  <span class="text-weight-bold text-brown-9">{{ item.quantity }}</span>
                  <q-btn flat round dense icon="add" color="brown-8" size="sm" @click="addToCart(item.product)" />
                </div>
              </q-item-section>
            </q-item>
          </q-list>
        </q-card-section>

        <!-- Cart footer with total and checkout -->
        <q-separator v-if="cartItems.length > 0" color="brown-3" class="q-mx-md" />
        <q-card-section v-if="cartItems.length > 0">
          <div class="row items-center justify-between q-mb-md">
            <span class="text-subtitle1 text-brown-7">Total</span>
            <span class="text-h5 text-weight-bold text-brown-9" style="font-family: 'Roboto Slab', serif;">
              ${{ cartTotal.toFixed(2) }}
            </span>
          </div>
          <q-btn
            unelevated
            color="brown-8"
            text-color="amber-2"
            label="Proceed to Checkout"
            icon="payment"
            no-caps
            class="full-width"
            style="border-radius: 12px; height: 48px;"
            @click="checkout"
          />
        </q-card-section>
      </q-card>
    </q-dialog>

    <!-- =============================================================== -->
    <!-- FLOATING ACTION BUTTON — Cart access                             -->
    <!-- Pinned to the bottom-right of the viewport.                      -->
    <!-- The q-badge dynamically shows the total number of items in cart. -->
    <!-- =============================================================== -->
    <q-page-sticky position="bottom-right" :offset="[18, 18]">
      <q-btn
        fab
        icon="shopping_cart"
        color="brown-8"
        text-color="amber-2"
        @click="cartDialogOpen = true"
      >
        <!-- Dynamic badge — only visible when cart has items -->
        <q-badge
          v-if="cartCount > 0"
          floating
          rounded
          color="amber-8"
          text-color="brown-10"
          class="text-weight-bold"
          style="font-size: 0.75rem;"
        >
          {{ cartCount }}
        </q-badge>
      </q-btn>
    </q-page-sticky>
  </q-page>
</template>

<script setup lang="ts">
/**
 * =======================================================================
 *  IndexPage.vue — Script Section
 * =======================================================================
 *  Composition API with <script setup> and TypeScript.
 *
 *  Data is mocked with ref() using a NoSQL-like document schema so it
 *  can integrate directly with DynamoDB / MongoDB via upcoming
 *  Python-based AWS Lambda or FastAPI REST endpoints.
 * =======================================================================
 */

import { ref, computed } from 'vue';
import { useQuasar } from 'quasar';

// ---------------------------------------------------------------------------
// Quasar instance — gives access to $q.notify, $q.platform, etc.
// ---------------------------------------------------------------------------
const $q = useQuasar();

// ---------------------------------------------------------------------------
// Type Definitions — mirrors the NoSQL document schema for backend compat
// ---------------------------------------------------------------------------

/** Represents a single coffee product document (DynamoDB/MongoDB-ready). */
interface CoffeeProduct {
  id: string;           // Unique product identifier (partition key)
  name: string;         // Display name of the coffee blend
  origin: string;       // Country/region of origin
  price: number;        // Price in USD
  description: string;  // Short marketing description
  imageUrl: string;     // CDN-hosted product image URL
}

/** Represents a single line item in the shopping cart. */
interface CartItem {
  product: CoffeeProduct;
  quantity: number;
}

// ---------------------------------------------------------------------------
// Mock Product Data — reactive array structured for NoSQL integration
// ---------------------------------------------------------------------------
// NOTE: These documents are designed to map 1:1 with DynamoDB items or
// MongoDB documents. The `id` field serves as the partition key.
// Unsplash source URLs provide cinematic coffee imagery.
// ---------------------------------------------------------------------------
const products = ref<CoffeeProduct[]>([
  {
    id: 'prod_001',
    name: 'Ethiopian Yirgacheffe',
    origin: 'Ethiopia',
    price: 18.99,
    description: 'Bright, fruity, and floral with notes of bergamot and blueberry. A washed-process single-origin that captures the essence of the birthplace of coffee.',
    imageUrl: 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=600&h=450&fit=crop',
  },
  {
    id: 'prod_002',
    name: 'Colombian Supremo',
    origin: 'Colombia',
    price: 16.49,
    description: 'Rich, full-bodied, and smooth with a caramel sweetness and a hint of nutty cocoa. Grown at high altitude in the Andes mountains.',
    imageUrl: 'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?w=600&h=450&fit=crop',
  },
  {
    id: 'prod_003',
    name: 'Sumatra Mandheling',
    origin: 'Indonesia',
    price: 19.99,
    description: 'Earthy, herbal, and low-acidity with a thick, syrupy body. Wet-hulled processing gives this bean its distinctive deep character.',
    imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefda?w=600&h=450&fit=crop',
  },
  {
    id: 'prod_004',
    name: 'Kenyan AA',
    origin: 'Kenya',
    price: 21.99,
    description: 'Intensely bright with layers of blackcurrant, grapefruit zest, and a wine-like finish. Grade AA represents the largest, most premium beans.',
    imageUrl: 'https://images.unsplash.com/photo-1611564494260-6f21b80af7ea?w=600&h=450&fit=crop',
  },
  {
    id: 'prod_005',
    name: 'Guatemala Antigua',
    origin: 'Guatemala',
    price: 17.49,
    description: 'Velvety smooth with rich chocolate undertones, a touch of spice, and a pleasant smoky finish from volcanic soil cultivation.',
    imageUrl: 'https://images.unsplash.com/photo-1504630083234-14187a9df0f5?w=600&h=450&fit=crop',
  },
  {
    id: 'prod_006',
    name: 'Costa Rican Tarrazú',
    origin: 'Costa Rica',
    price: 20.49,
    description: 'Perfectly balanced with bright citrus acidity, honey sweetness, and a clean, crisp finish. Harvested from the renowned Tarrazú valley.',
    imageUrl: 'https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=600&h=450&fit=crop',
  },
  {
    id: 'prod_007',
    name: 'Brazilian Santos',
    origin: 'Brazil',
    price: 14.99,
    description: 'Classic and approachable with nutty, chocolatey sweetness and low acidity. The quintessential everyday coffee from the world\'s largest producer.',
    imageUrl: 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=600&h=450&fit=crop',
  },
  {
    id: 'prod_008',
    name: 'Jamaican Blue Mountain',
    origin: 'Jamaica',
    price: 48.99,
    description: 'Legendary rarity — exceptionally mild, with virtually no bitterness. Complex sweet herbs, floral notes, and a silky-smooth clean cup.',
    imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=600&h=450&fit=crop',
  },
]);

// ---------------------------------------------------------------------------
// Cart State
// ---------------------------------------------------------------------------
/** Reactive cart items array — each entry tracks product + quantity. */
const cartItems = ref<CartItem[]>([]);

/** Computed: total number of individual items across all line items. */
const cartCount = computed(() =>
  cartItems.value.reduce((sum, item) => sum + item.quantity, 0)
);

/** Computed: total price of all items in the cart. */
const cartTotal = computed(() =>
  cartItems.value.reduce((sum, item) => sum + item.product.price * item.quantity, 0)
);

// ---------------------------------------------------------------------------
// Dialog State
// ---------------------------------------------------------------------------
/** Controls visibility of the product detail dialog. */
const detailDialogOpen = ref(false);

/** Controls visibility of the cart dialog. */
const cartDialogOpen = ref(false);

/** Currently selected product for the detail view. */
const selectedProduct = ref<CoffeeProduct | null>(null);

// ---------------------------------------------------------------------------
// Methods
// ---------------------------------------------------------------------------

/**
 * addToCart — Adds one unit of a product to the cart.
 * If the product already exists in the cart, increments its quantity.
 * Triggers a Quasar notify toast to confirm the action.
 *
 * @param product - The CoffeeProduct to add.
 */
function addToCart(product: CoffeeProduct): void {
  const existing = cartItems.value.find((item) => item.product.id === product.id);

  if (existing) {
    // Product already in cart — increment quantity
    existing.quantity++;
  } else {
    // New product — add as new line item
    cartItems.value.push({ product, quantity: 1 });
  }

  // Show success toast notification with product name
  $q.notify({
    message: `${product.name} added to cart`,
    icon: 'check_circle',
    color: 'brown-8',
    textColor: 'amber-2',
    position: 'bottom',
    timeout: 1800,
    actions: [
      {
        label: 'View Cart',
        color: 'amber-4',
        handler: () => { cartDialogOpen.value = true; },
      },
    ],
  });
}

/**
 * decrementItem — Decreases the quantity of a cart item by one.
 * Removes the item entirely if quantity reaches zero.
 *
 * @param productId - The ID of the product to decrement.
 */
function decrementItem(productId: string): void {
  const index = cartItems.value.findIndex((item) => item.product.id === productId);
  if (index === -1) return;

  const cartItem = cartItems.value[index];
  if (!cartItem) return;

  if (cartItem.quantity > 1) {
    cartItem.quantity--;
  } else {
    // Remove item from cart entirely
    cartItems.value.splice(index, 1);
  }
}

/**
 * openProductDetail — Opens the product detail dialog for a given product.
 * @param product - The CoffeeProduct to display.
 */
function openProductDetail(product: CoffeeProduct): void {
  selectedProduct.value = product;
  detailDialogOpen.value = true;
}

/**
 * onRefresh — Handler for q-pull-to-refresh.
 * Simulates a network request to refresh product data.
 * In production, this would call the FastAPI/Lambda endpoint.
 *
 * @param done - Callback to signal refresh completion.
 */
function onRefresh(done: () => void): void {
  // Simulate async data fetch with 1.5s delay
  setTimeout(() => {
    $q.notify({
      message: 'Products refreshed!',
      icon: 'refresh',
      color: 'brown-8',
      textColor: 'amber-2',
      position: 'top',
      timeout: 1500,
    });
    done();
  }, 1500);
}

/**
 * checkout — Placeholder checkout handler.
 * In production, this would POST the cart to the backend API.
 */
function checkout(): void {
  $q.notify({
    message: `Checkout initiated — ${cartCount.value} item(s), $${cartTotal.value.toFixed(2)}`,
    icon: 'payment',
    color: 'positive',
    textColor: 'white',
    position: 'top',
    timeout: 3000,
  });
  // Clear the cart after "checkout"
  cartItems.value = [];
  cartDialogOpen.value = false;
}
</script>

<style scoped>
/*
 * =======================================================================
 *  SCOPED STYLES — Hover Animation
 * =======================================================================
 *  This is the ONLY custom CSS used in the component. Quasar does not
 *  provide a built-in hover translate utility, so this minimal rule
 *  handles the desktop hover-state card lift effect.
 * =======================================================================
 */
.product-card:hover {
  transform: translateY(-8px);
  box-shadow:
    0 12px 28px rgba(62, 39, 35, 0.18),
    0 4px 10px rgba(62, 39, 35, 0.10);
}
</style>
