<script setup>
import Swal from 'sweetalert2'

definePageMeta({
    layout: 'forgot',
})
//si le compte n'existe pas lien expire
onMounted(() => {
  const route = useRoute();
  const condition = route.query.code;
  if (condition) {
    Swal.fire({
      text: 'Lien de réinitialisation expiré',
      icon: 'error',
      confirmButtonText: 'Ok'
    })
  }
})

useHead({
  title: 'EventPass - Forgot Password',
  meta: [
    { name: 'description', content: 'Podux Podcast landing page website.' },
  ],
  link: [
    { rel: 'icon', type: 'image/png', href: '/logo.png' }
  ],
})
</script>
<template>
    <ForgotPassword />
</template>