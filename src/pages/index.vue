<template>
  <!--
    =====================================================================
    Layout — Aroma Roasters
    =====================================================================
    Main application layout with themed header, navigation drawer,
    and page container. Uses a dark coffee-inspired color scheme.
    =====================================================================
  -->
  <q-layout view="lHh Lpr lFf">

    <!-- =============================================================== -->
    <!-- HEADER — Dark coffee-toned toolbar with branding                 -->
    <!-- =============================================================== -->
    <q-header elevated class="bg-brown-10">
      <q-toolbar class="q-px-md" style="height: 56px;">
        <!-- Menu toggle — only visible on mobile / when drawer is hidden -->
        <q-btn
          flat
          dense
          round
          icon="menu"
          color="amber-3"
          aria-label="Menu"
          @click="toggleLeftDrawer"
        />

        <!-- Store branding -->
        <q-toolbar-title class="text-amber-2 text-weight-bold" style="font-family: 'Roboto Slab', serif; letter-spacing: 1.5px;">
          <q-icon name="local_cafe" size="24px" class="q-mr-xs" style="vertical-align: middle;" />
          Aroma Roasters
        </q-toolbar-title>

        <!-- Subtle version badge for dev reference -->
        <q-badge outline color="amber-8" text-color="amber-4" class="text-caption q-px-sm" style="border-radius: 8px;">
          v0.1.0
        </q-badge>
      </q-toolbar>
    </q-header>

    <!-- =============================================================== -->
    <!-- NAVIGATION DRAWER — themed sidebar with helpful links            -->
    <!-- =============================================================== -->
    <q-drawer
      v-model="leftDrawerOpen"
      show-if-above
      bordered
      class="bg-brown-9"
      :width="260"
    >
      <!-- Drawer header -->
      <div class="q-pa-md text-center">
        <q-icon name="local_cafe" size="40px" color="amber-4" />
        <div class="text-subtitle1 text-amber-2 text-weight-bold q-mt-xs" style="letter-spacing: 1px;">
          AROMA ROASTERS
        </div>
        <div class="text-caption text-brown-4">Artisan Coffee Store</div>
      </div>

      <q-separator color="brown-7" />

      <!-- Navigation links -->
      <q-list class="q-mt-sm">
        <q-item-label header class="text-brown-4 text-caption text-weight-medium" style="letter-spacing: 0.5px;">
          NAVIGATION
        </q-item-label>

        <q-item clickable v-ripple active class="text-amber-2">
          <q-item-section avatar>
            <q-icon name="storefront" color="amber-4" />
          </q-item-section>
          <q-item-section class="text-weight-medium">Store</q-item-section>
        </q-item>

        <q-item clickable v-ripple class="text-brown-3">
          <q-item-section avatar>
            <q-icon name="favorite_border" color="brown-4" />
          </q-item-section>
          <q-item-section>Favorites</q-item-section>
        </q-item>

        <q-item clickable v-ripple class="text-brown-3">
          <q-item-section avatar>
            <q-icon name="history" color="brown-4" />
          </q-item-section>
          <q-item-section>Order History</q-item-section>
        </q-item>

        <q-separator color="brown-7" class="q-my-sm" />

        <q-item-label header class="text-brown-4 text-caption text-weight-medium" style="letter-spacing: 0.5px;">
          RESOURCES
        </q-item-label>

        <EssentialLink
          v-for="link in linksList"
          :key="link.label"
          v-bind="link"
        />
      </q-list>
    </q-drawer>

    <!-- =============================================================== -->
    <!-- PAGE CONTAINER — renders the routed page component                -->
    <!-- =============================================================== -->
    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script setup lang="ts">
/**
 * Layout script — manages drawer state and navigation links.
 */
import { ref } from 'vue';
import EssentialLink, { type EssentialLinkProps } from '@/components/EssentialLink.vue';

// Sidebar navigation resource links
const linksList: EssentialLinkProps[] = [
  {
    label: 'Quasar Docs',
    caption: 'quasar.dev',
    icon: 'school',
    link: 'https://quasar.dev',
  },
  {
    label: 'GitHub',
    caption: 'github.com/quasarframework',
    icon: 'code',
    link: 'https://github.com/quasarframework',
  },
  {
    label: 'Community',
    caption: 'forum.quasar.dev',
    icon: 'forum',
    link: 'https://forum.quasar.dev',
  },
];

// Drawer visibility state
const leftDrawerOpen = ref(false);

/** Toggles the left navigation drawer open/closed. */
function toggleLeftDrawer(): void {
  leftDrawerOpen.value = !leftDrawerOpen.value;
}
</script>
