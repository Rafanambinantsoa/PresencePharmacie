<script setup>
definePageMeta({
    layout: 'admin',
    middleware: 'admin'
})

useHead({
  title: 'EventPass - Admin',
  meta: [
    { name: 'description', content: 'Podux Podcast landing page website.' },
  ],
  link: [
    { rel: 'icon', type: 'image/png', href: '/logo.png' }
  ],
})
</script>
<template>
    <Admin />
</template>