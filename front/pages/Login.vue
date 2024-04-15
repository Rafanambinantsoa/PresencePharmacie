<script setup >
//import swal
import Swal from 'sweetalert2'
definePageMeta({
  layout: "login",
})
useHead({
  title: 'EventPass - Login',
  meta: [
    { name: 'description', content: 'Podux Podcast landing page website.' },
  ],
  link: [
    { rel: 'icon', type: 'image/png', href: '/logo.png' }
  ],
})

onMounted(() => {
  const route = useRoute();
  const condition = route.query.code;
  if (condition) {
    if (condition == "success") {
      Swal.fire({
        icon: 'success',
        title: 'Vous compte a été activé avec succès',
        showConfirmButton: false,
        timer: 3000
      })
    }
    else {
      Swal.fire({
        icon: 'error',
        title: 'Votre compte n\'a pas été activé ou bien votre lien a expiré',
        showConfirmButton: false,
        timer: 1500
      })
    }
  }
})
</script>
<template>
  <Login />
</template>