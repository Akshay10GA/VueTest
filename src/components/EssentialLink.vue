<template>
  <q-item clickable v-ripple tag="a" target="_blank" :href="link" class="text-brown-3">
    <q-item-section v-if="icon" avatar>
      <q-icon :name="icon" color="brown-4" />
    </q-item-section>

    <q-item-section>
      <q-item-label class="text-brown-3">{{ label }}</q-item-label>
      <q-item-label caption class="text-brown-5">{{ caption }}</q-item-label>
    </q-item-section>
  </q-item>
</template>

<script setup lang="ts">
export interface EssentialLinkProps {
  label: string;
  caption?: string;
  link?: string;
  icon?: string;
}

withDefaults(defineProps<EssentialLinkProps>(), {
  caption: '',
  link: '#',
  icon: '',
});
</script>
