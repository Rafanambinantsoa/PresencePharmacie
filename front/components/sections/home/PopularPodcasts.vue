<script lang="ts" setup>
import { toast } from 'vue3-toastify';
import 'vue3-toastify/dist/index.css';
import { uri } from '~/stores/uri';

const token = useCookie("token")
const { data: allEvent } = await useAsyncData("", () =>
    $fetch(`${uri}all`, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    })
);

//afficher le modal avec les données récupérées
import { ref } from 'vue';

// Créez une référence pour stocker les données récupérées depuis l'API
const donnee = ref(null);

async function oneEvent(id) {
    console.log(id);
    try {
        // Utilisez la méthode $fetch de Nuxt.js pour récupérer les données depuis l'API
        const response = await $fetch(`${uri}event/${id}`, {
            headers: {
                'Authorization': 'Bearer ' + token.value
            }
        });

        // Vérifiez si la réponse a réussi et stockez les données dans la référence 'donee'
        if (response) {
            donnee.value = response;
            my_modal_4.showModal();
            // Affichez les données dans la console pour vérifier si tout fonctionne correctement
            console.log(donnee.value);
            // Affichez le modal avec les données récupérées
        }
    } catch (error) {
        console.error("Une erreur s'est produite lors de la récupération des données :", error);
    }
}
//Ajout dans le panier
import { useCartStore } from '~/stores/cart';
const cart = useCartStore()

const incr = (bulle) => {
    console.log("incr");
    const isProductInCart = cart.cartItems.some((item) => item.id === bulle.id);

    if (!isProductInCart) {
        // Le produit n'est pas dans le panier, nous pouvons l'ajouter
        bulle.quantity = 1;
        cart.addToCart(bulle);
        //toast 
        toast.success('Ajouté au panier !', {
            autoClose: 2000,
        });
    }
    else {
        // Le produit est déjà dans le panier, nous pouvons l'incrémenter
        //toast 
        toast.error('Produit deja dans le panier', {
            autoClose: 2000,
        });
    }

}


</script>

<template>
    <section id="allEvents" class="pt-16 relative">
        <div aria-hidden="true" class="absolute inset-y-0 w-44 left-0 hidden dark:flex">
            <div
                class="h-full md:h-1/2 lg:h-full w-full bg-gradient-to-tr opacity-40 dark:blur-2xl dark:from-[#570cac] dark:opacity-20">
            </div>
        </div>
        <div class="absolute top-14 inset-x-0 h-64 flex items-start">
            <div
                class="h-24 w-2/3 bg-gradient-to-br from-primary opacity-20 blur-2xl dark:from-[#570cac] dark:invisible dark:opacity-40">
            </div>
            <div
                class="h-20 w-3/5 bg-gradient-to-r from-[#8cd66a] opacity-40 blur-2xl dark:from-[#670ccf] dark:opacity-40">
            </div>
        </div>
        <AtomsContainer class-name="relative">
            <div class="flex justify-between pb-6 relative">
                <div class="">
                    <AtomsTitle texte="Tous les Événements" />
                </div>
                <div class="flex items-center min-w-max gap-5">
                    <!-- <AtomsLinkBtn href="#" variant="primary">
                        Search Events
                    </AtomsLinkBtn> -->
                </div>
            </div>

            <dialog id="my_modal_4" class="modal">
                <div class="flex font-sans">
                </div>
                <form method="dialog" class="modal-box w-11/12 max-w-5xl h-auto">
                    <button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">✕</button>
                    <!-- Utilisez la directive v-if pour conditionner l'affichage des données -->
                    <div v-if="donnee">
                        <div class="flex">
                            <div class="w-1/2 p-4">
                                <!-- Ajoutez une condition pour afficher l'image uniquement si elle est disponible -->
                                <img class="bg-cover h-60 w-80" :src="'http://localhost:8000/' + donnee.image" alt="">
                            </div>
                            <div class="w-1/2 bg-auto-200 p-4">
                                <h3 v-if="donnee.titre"> {{ donnee.titre }} </h3>
                                <p class="underline hover:underline-offset-4">Description :</p>
                                <p v-if="donnee.description" class="mb-4"> {{ donnee.description }} </p>
                                <p v-if="donnee.date && donnee.lieu && donnee.heure">Soyez au rendez-vous {{
                        donnee.date }}, lieu {{ donnee.lieu }}, à {{
                        donnee.heure }} h. Billets en ligne disponibles ! Ne manquez pas cette
                                    occasion
                                    unique !</p>
                                <button type="button" v-if="donnee" @click="incr(donnee)"
                                    class=" mt-5 text-white bg-green-700 hover:bg-green-800 focus:ring-4 focus:outline-none focus:ring-green-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center inline-flex items-center mr-2 dark:bg-green-600 dark:hover:bg-green-700 dark:focus:ring-green-800">
                                    <svg class="w-3.5 h-3.5 mr-2" aria-hidden="true" xmlns="http://www.w3.org/2000/svg"
                                        fill="currentColor" viewBox="0 0 18 21">
                                        <path
                                            d="M15 12a1 1 0 0 0 .962-.726l2-7A1 1 0 0 0 17 3H3.77L3.175.745A1 1 0 0 0 2.208 0H1a1 1 0 0 0 0 2h.438l.6 2.255v.019l2 7 .746 2.986A3 3 0 1 0 9 17a2.966 2.966 0 0 0-.184-1h2.368c-.118.32-.18.659-.184 1a3 3 0 1 0 3-3H6.78l-.5-2H15Z" />
                                    </svg>
                                    Ajouter dans le panier
                                </button>
                            </div>
                        </div>
                    </div>
                    <!-- Ajoutez une condition pour afficher un message si les données ne sont pas encore disponibles -->
                    <div v-else>
                        Chargement des données...
                    </div>
                </form>
            </dialog>

            <div
                class="grid grid-cols-2 items-stretch sm:grid-cols-3 lg:grid-cols-4 gap-x-3 gap-y-10 sm:gap-x-5 sm:gap-y-8">

                <div v-for="event in allEvent"
                    class="lg:p-1 relative h-auto flex flex-col lg:rounded-2xl lg:bg-box-bg lg:shadow-lg lg:shadow-box-shadow lg:border lg:border-box-border">
                    <div class="relative h-max min-h-max">
                        <nuxt-img :src="'http://localhost:8000/' + event.image" alt="Cover image" width="280"
                            class="w-full h-32 sm:h-36 md:h-40 lg:h-48 rounded-xl object-cover" />
                        <span class="absolute top-2 right-2 px-2 rounded-full text-sm text-white bg-primary">
                            {{ event.heure }} h
                        </span>
                    </div>
                    <div class="lg:px-2 pt-2 lg:pb-4 xl:px-4 md:pt-4  h-full flex flex-col justify-between">
                        <div class="h-full">
                            <h2
                                class="font-semibold text-base md:text-lg lg:text-xl line-clamp-2 md:line-clamp-3 text-gray-700 dark:text-white">
                                {{ event.titre }} <br>
                                {{ event.description }}
                            </h2>
                        </div>
                        <div class="pt-3 sm:pt-5 min-h-max h-max">
                            <button type="button" @click="oneEvent(event.id)"
                                class="text-[#374151] border-2 border-green-500  bg-shadow-blue-700 hover:bg-shadow-blue-800 focus:ring-4 focus:outline-none focus:ring-shadow-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center inline-flex items-center dark:bg-shadow-blue-600 dark:hover:bg-shadow-blue-700 dark:border-0">
                                Voir les details
                                <svg class="w-3.5 h-3.5 ml-2" aria-hidden="true" xmlns="http://www.w3.org/2000/svg"
                                    fill="none" viewBox="0 0 14 10">
                                    <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
                                        stroke-width="2" d="M1 5h12m0 0L9 1m4 4L9 9" />
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>





            </div>
        </AtomsContainer>
    </section>
</template>