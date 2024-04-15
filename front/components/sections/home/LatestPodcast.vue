<script lang="ts" setup>
import { toast } from 'vue3-toastify';
import 'vue3-toastify/dist/index.css';
import { uri } from '~/stores/uri';


const token = useCookie("token")


const { data: latestEvent } = await useAsyncData("", () =>
    $fetch(`${uri}latest`, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    })
);

// const scrollLeft = useState('scrollLeft', ()=> 0)
const nextIsVisible = useState('nextIsVisible', () => false)
const prevIsVisible = useState('prevIsVisible', () => false)

let element: HTMLDivElement
if (typeof document !== "undefined") {
    element = document.querySelector("[data-slide-recent]") as HTMLDivElement
}
function initScroll(): void {
    if (typeof element === "undefined" || element === null) {
        return
    }
    prevIsVisible.value = element.scrollLeft <= 0 ? false : true
    nextIsVisible.value = element.scrollLeft >= element.scrollWidth - element.offsetWidth - 1 ? false : true
}

function scrollToLeft(): void {
    if (typeof element === "undefined" || element === null) {
        return
    }
    element.scrollLeft -= element.clientWidth
}

function scrollToRight(): void {
    if (typeof element === "undefined" || element === null) {
        return
    }
    element.scrollLeft += element.clientWidth
}

onMounted(() => {
    if (window !== null) {
        initScroll()
    }
})

//afficher le modal avec les données récupérées

// Créez une référence pour stocker les données récupérées depuis l'API
const donnee = ref(null);

async function oneEvent(id) {
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
            loui.showModal();
            // Affichez les données dans la console pour vérifier si tout fonctionne correctement
            console.log(donnee.value);
            // Affichez le modal avec les données récupérées
        }
    } catch (error) {
        console.error("Une erreur s'est produite lors de la récupération des données :", error);
    }
}
// console.log(donnee);

// Panier 
import { useCartStore } from '~/stores/cart';
const cart = useCartStore();

const incr = (bulle) => {
    console.log("incr");
    const isProductInCart = cart.cartItems.some((item) => item.id === bulle.id);

    if (!isProductInCart) {
        // Le produit n'est pas dans le panier, nous pouvons l'ajouter
        bulle.quantity = 1;
        cart.addToCart(bulle);
        //toast 
        toast.success('Produit ajouté au panier', {
            autoClose: 3000,
        });
    }
    else {
        toast.error('Produit deja dans le panier', {
            autoClose: 3000,
        });
    }

}

//recheche 
function search() {
    recherche.showModal()
    console.log("cliqued");
}


</script>
<template>
    <section id="latestEvent" class="pt-20 md:pt-24 relative">
        <AtomsContainer>
            <div class="relative">
                <div class="flex justify-between pb-6 relative">
                    <div class="">
                        <AtomsTitle texte="Événements Récents" />
                    </div>
                    <div class="flex items-center min-w-max gap-5">
                        <AtomsTitle @click="search" texte="Rechercher un Event  🔎" />


                        <!-- modal -->
                        <dialog id="loui" class="modal">
                            <div class="flex font-sans">
                            </div>
                            <form method="dialog" class="modal-box w-11/12 max-w-5xl h-auto">
                                <button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">✕</button>
                                <!-- Utilisez la directive v-if pour conditionner l'affichage des données -->
                                <div v-if="donnee">
                                    <div class="flex">
                                        <div class="w-1/2 p-4">
                                            <!-- Ajoutez une condition pour afficher l'image uniquement si elle est disponible -->
                                            <img class="bg-cover h-60 w-80"
                                                :src="'http://localhost:8000/' + donnee.image" alt="">
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
                                                class="mt-5 text-white bg-green-700 hover:bg-green-800 focus:ring-4 focus:outline-none focus:ring-green-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center inline-flex items-center mr-2 dark:bg-green-600 dark:hover:bg-green-700 dark:focus:ring-green-800">
                                                <svg class="w-3.5 h-3.5 mr-2" aria-hidden="true"
                                                    xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                                                    stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                        stroke-width="2" d="M9 5l7 7-7 7"></path>
                                                </svg>
                                                Recevoir une invitation
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

                    </div>
                </div>
                <!-- MOdal recherche  -->
                <dialog id="recherche" class="modal">
                    <div class="modal-box  w-full h-auto">
                        <p class="py-4">Rechecher un événement</p>
                        <input type="text" v-model="searchQuery" placeholder=" Veuiller taper le mot cle svp"
                            class="input  w-full max-w-xs" />
                        <div v-if="searchQuery.length > 0 && searchResults.length > 0">
                            <ul class="menu menu-md bg-base-200 w-full mt-5 rounded-box">
                                <li v-for="result in searchResults" :key="result.id"><a @click="oneEvent(result.id)">{{
                            result.titre }}</a></li>
                            </ul>
                        </div>
                        <div v-else-if="searchResults.length <= 0">
                            <ul class="menu menu-md bg-base-200 w-full mt-5 rounded-box text=center">
                                <li><a>je trouve pas l'event "{{ searchQuery }}" </a></li>
                            </ul>
                        </div>

                        <div class="modal-action">
                            <form method="dialog">
                                <!-- if there is a button, it will close the modal -->
                                <button class="btn">Fermer</button>
                            </form>
                        </div>
                    </div>
                </dialog>
                <!-- MOdal recherche fin  -->


                <div class="flex absolute top-1/2 -left-5 -translate-y-1/2 z-10 transition duration-300 ease-linear"
                    :class="prevIsVisible ? 'visible opacity-100' : 'insisible opacity-0'">
                    <AtomsSwiperNavButton @click="scrollToLeft()">
                        <IconsPrevIco />
                    </AtomsSwiperNavButton>
                </div><!--  -->
                <div class="flex absolute top-1/2 -right-5 -translate-y-1/2 z-10 transition duration-300 ease-linear"
                    :class="nextIsVisible ? 'visible opacity-100' : 'insisible opacity-0'">
                    <AtomsSwiperNavButton @click="scrollToRight()">
                        <IconsNextIco />
                    </AtomsSwiperNavButton>
                </div>

                <div data-slide-recent @scroll="initScroll()"
                    class="flex items-stretch gap-5 overflow-hidden overflow-x-auto invisible-scroll">

                    <div v-for=" mike in latestEvent"
                        class=" w-11/12 min-w-[91.666667%] xs:w-80 xs:min-w-[20rem] md:w-1/3 md:min-w-[33.333333%] lg:w-1/4 lg:min-w-[25%]">
                        <div class="w-full relative rounded-2xl overflow-hidden">
                            <nuxt-img :src="'http://localhost:8000/' + mike.image" alt="Cover image" width="2280"
                                class="w-full aspect-square object-cover rounded-2xl" />
                            <span class="absolute top-2 right-2 px-2 rounded-full text-sm text-white bg-primary">
                                {{ mike.heure }}h
                            </span>
                            <div
                                class="absolute py-2 px-3 md:py-3 md:px-4 bottom-0 h-28 flex flex-col justify-between inset-x-0 bg-gradient-to-t from-gray-800 bg-opacity-50 backdrop-filter backdrop-blur-sm">
                                <h2 class="text-white font-semibold text-sm sm:text-base line-clamp-2">
                                    {{ mike.titre }} <br>
                                    {{ mike.description }}
                                </h2>
                                <div class="pt-2">
                                    <button @click="oneEvent(mike.id)"
                                        class="flex items-center text-white rounded-full p-0.5 pr-2 gap-2 text-sm border border-gray-100/20 w-max">
                                        <span class="p-1 rounded-full bg-primary">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                                                viewBox="0 0 24 24" fill="currentColor" class="w-3 h-3">
                                                <path fill-rule="evenodd"
                                                    d="M4.5 5.653c0-1.426 1.529-2.33 2.779-1.643l11.54 6.348c1.295.712 1.295 2.573 0 3.285L7.28 19.991c-1.25.687-2.779-.217-2.779-1.643V5.653z"
                                                    clip-rule="evenodd" />
                                            </svg>
                                        </span>
                                        voir les details
                                    </button>
                                </div>
                            </div>
                        </div>

                    </div>


                </div>
            </div>
        </AtomsContainer>
    </section>
</template>
<script lang="ts">
export default {
    data() {
        return {
            searchQuery: '',
            data: [] // initialiser les données avec un tableau vide
        };
    },
    async mounted() {
        let token = useCookie("token"); // utilisez useCookie ici sans le préfixe this
        const response = await $fetch(`${uri}marie`, {
            headers: {
                'Authorization': 'Bearer ' + token.value
            }
        });
        this.data = await response; // mettez à jour les données après avoir reçu la réponse
    },
    computed: {
        searchResults() {
            return this.data.filter(item => {
                return item.titre.toLowerCase().includes(this.searchQuery.toLowerCase());
            });
        }
    },
};
</script>