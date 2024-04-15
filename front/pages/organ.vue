<script setup>
definePageMeta({
    layout: 'organizers',
    middleware: 'organ'
})

useHead({
  title: 'EventPass - Organizers',
  meta: [
    { name: 'description', content: 'Podux Podcast landing page website.' },
  ],
  link: [
    { rel: 'icon', type: 'image/png', href: '/logo.png' }
  ],
})
</script>
<template>
    <Organizers />
</template>