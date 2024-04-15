<script setup>
import Swal from 'sweetalert2'
definePageMeta({
  middleware: 'auth'
})

useHead({
  title: 'EventPass - Home',
  meta: [
    { name: 'description', content: 'Podux Podcast landing page website.' },
  ],
  link: [
    { rel: 'icon', type: 'image/png', href: '/logo.png' }
  ],
})

const token = useCookie("token");


//Nom admin
const { data: users } = await useAsyncData("Users", () =>
    $fetch("http://localhost:8000/api/user", {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    })
);




onMounted(() => {
  const route = useRoute();
  const condition = route.query.code;
  const message = route.query.message;
  if (condition) {
    Swal.fire({
      text: 'Vos billets ont été payé et envoyé par email avec succès',
      icon: 'success',
      confirmButtonText: 'Ok'
    })
  }
  if (message) {
    Swal.fire({
      title: "Veuillez confirmer votre annulation de commande",
      confirmButtonText: "Confirmer l'annulation",
      allowOutsideClick: false,

    }).then((result) => {
      if (result.isConfirmed) {
        //appel api pour annuler la commande get 
        $fetch(`http://localhost:8000/api/annulerCommandeParUser/${users.value.id}`, {
          method: 'GET',
        }).then((response) => {
          console.log(response);
        })

      }
    });
  }

})



const vToken = useCookie("vanila" , {
    maxAge: 60*60*60
})
async function vanilaPay() {
    const id = process.env.CLIENT_ID;
    const secret = process.env.CLIENT_SECRET;

    const { data: vanila } = await useAsyncData("Vanila", () =>
        $fetch(`https://pro.ariarynet.com/oauth/v2/token?client_id=${id}&client_secret=${secret}&grant_type=client_credentials`, {
        })
    );
    console.log(vanila.value.access_token);
    vToken.value = vanila.value.access_token

}

vanilaPay()


</script>
<template>
  <div>
    <SectionsHomeHeroSection />
    <SectionsHomeLatestPodcast />
    <SectionsHomePopularPodcasts />
    <SectionsAboutPodux />
    <SectionsWhyUs />
    <SectionsCallToAction />
  </div>
</template>