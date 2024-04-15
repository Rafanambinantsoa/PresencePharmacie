<script setup>
import { toast } from 'vue3-toastify';
import 'vue3-toastify/dist/index.css';
import { uri } from '~/stores/uri';



//Nom admin
const token = useCookie("token");
const users = await useAsyncData("Users", () =>
    $fetch(`${uri}user`, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    })
);


//Pour se deconnecter
function logout() {
    document.cookie = "token=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;"
    document.cookie = "idao=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;"
}

//Pour obtenir le nombre d'evenement que l'utilisateurs a  creer
const nbEventTotal = await useAsyncData("nbEventtotal", () =>
    $fetch(`${uri}count/${users.data.value.id}`, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    })
);

//Les nombres des events encours
const nbUsers = await useAsyncData("nbEventcours", () =>
    $fetch(`${uri}client/count`, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    })
);


//Pagination
const EventEncours = ref([]);

const getNextEvents = async () => {
    if (!EventEncours.value.next_page_url) return;
    const response = await $fetch(EventEncours.value.next_page_url, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    });
    EventEncours.value = response;
    // fetchInitialData()

};

const getPreviousEvents = async () => {
    if (!EventEncours.value.prev_page_url) return;
    const response = await $fetch(EventEncours.value.prev_page_url, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    });
    EventEncours.value = response;
};

// Récupérer les données initiales
const fetchInitialData = async () => {
    const response = await $fetch(`${uri}eventEncoursPaginated`, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    });
    EventEncours.value = response;
};

onMounted(() => {
    fetchInitialData();
    fetchInitialDataAll()
})

//Paginate tout les events j'ai creer
const all = ref([]);

const getNextEventsAll = async () => {
    if (!all.value.next_page_url) return;
    const response = await $fetch(all.value.next_page_url, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    });
    all.value = response;
    // fetchInitialData()

};

const getPreviousEventsAll = async () => {
    if (!all.value.prev_page_url) return;
    const response = await $fetch(all.value.prev_page_url, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    });
    all.value = response;
};

// Récupérer les données initiales
const fetchInitialDataAll = async () => {
    const response = await $fetch(`${uri}user/all`, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    });
    all.value = response;
};

let sam = {
    titre: '',
    heure: '',
    date: null,
    description: null,
    lieu: '',
    prix: '',
    limitBillets: 0,
    image: null,
    erreur: ""
}

//Rafraichier tous les donnes 
const refreshAll = () => {
    refreshNuxtData('nbEventtotal')
    refreshNuxtData('nbEventcours')
    refreshNuxtData('Eventencours')
    refreshNuxtData('Eventterminer')
    refreshNuxtData('Revenustotal')
    refreshNuxtData('All')
}

//Traitement de l'image
const handleImageChange = (e) => {
    return sam.image = e.target.files[0]
};



const creerEvent = () => {
    const date = new Date(sam.date);
    const dateNormale = new Date();
    //Date aujourd'hui plus 7 jours
    const dateNow = new Date();
    dateNow.setDate(dateNow.getDate() + 5);
    //controle champs vide
    if (sam.titre == '' || sam.heure == '' || sam.date == null || sam.description == null || sam.lieu == '') {
        toast.warning('Veuillez completer tous le champs', {
            autoClose: 3000,
        })
        return
    } else if (date < dateNormale) {
        toast.warning('Veuillez choisir une date valide', {
            autoClose: 3000,
        })
        return
    }
    else if (date < dateNow) {
        toast.warning('Date limite : 5 jours avant.', {
            autoClose: 3000,
        })
        return
    }
    const formData = new FormData();
    formData.append('titre', sam.titre);
    formData.append('heure', sam.heure);
    formData.append('date', sam.date);
    formData.append('description', sam.description);
    formData.append('lieu', sam.lieu);
    formData.append('user_id', users.data.value.id);
    useFetch(`${uri}create_event`, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        },
        method: 'POST',
        body: formData
    }).then((res) => {
        console.log(res.data.value.message)
        if (res.data.value.message == "success") {
            // console.log("success");
            toast.success("Creation Evénements succes")
            refreshAll()
            fetchInitialData()

            sam.titre = ''
            sam.heure = ''
            sam.date = null
            sam.description = null
            sam.lieu = ''
            sam.prix = ''
            sam.limitBillets = 0
            sam.image = null
        }
    })
}


const detailEvent = ref(null);


// Affichage de details d'un event en cours 
const oneEvent = async (id) => {
    try {
        // Utilisez la méthode $fetch de Nuxt.js pour récupérer les données depuis l'API
        const response = await $fetch(`${uri}event/${id}`, {
            headers: {
                'Authorization': 'Bearer ' + token.value
            }
        });

        // Vérifiez si la réponse a réussi et stockez les données dans la référence 'donee'
        if (response) {
            detailEvent.value = response;
            detail.showModal();
            // Affichez les données dans la console pour vérifier si tout fonctionne correctement
            // console.log(detailEvent.value);
            // Affichez le modal avec les données récupérées
        }
    } catch (error) {
        console.error("Une erreur s'est produite lors de la récupération des données :", error);
    }
}


const mettreAjour = (id) => {
    //controle champas date
    const date = new Date(detailEvent.value.date);
    const dateNormale = new Date();
    //plus 5 jours
    const dateNow = new Date();
    dateNow.setDate(dateNow.getDate() + 5);
    if (date < dateNormale) {
        toast.warning('Veuillez choisir une date valide', {
            autoClose: 3000,
        })
        return
    }
    else if (date < dateNow) {
        toast.warning('Date limite : 5 jours avant.', {
            autoClose: 3000,
        })
        return
    }
    if (detailEvent.value.titre == '' || detailEvent.value.heure == '' || detailEvent.value.date == null || detailEvent.value.description == null || detailEvent.value.lieu == '' || detailEvent.value.prix == '' || detailEvent.value.limitBillets == 0) {
        toast.warning('Veuillez completer tous le champs', {
            autoClose: 3000,
        })
        return
    }
    if (detailEvent.value.limitBillets <= 40) {
        toast.warning('nombre de billets 50 minimum', {
            autoClose: 3000,
        })
        return
    }
    if (detailEvent.value.prix <= 5000) {
        toast.warning('Prix minimum 5.000 Ar', {
            autoClose: 3000,
        })
        return
    }
    useFetch(`${uri}update/${id}`, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        },
        method: 'PUT',
        body: {
            'titre': detailEvent.value.titre,
            'heure': detailEvent.value.heure,
            'date': detailEvent.value.date,
            'description': detailEvent.value.description,
            'lieu': detailEvent.value.lieu,
            'prix': detailEvent.value.prix,
            'limitBillets': detailEvent.value.limitBillets,

        }
    }).then((res) => {
        console.log(res)
        toast.success("Mise a jour succes", {
            autoClose: 3000,
        })
        refreshAll()
        fetchInitialData()
    })

}


//La listes des presents 
const lesPresents = ref(null);

const getPresent = async (id) => {
    try {
        const response = await $fetch(`${uri}event/listPresence/${id}`, {
            headers: {
                'Authorization': 'Bearer ' + token.value
            }
        });

        if (response) {
            modalPresent.showModal();
            lesPresents.value = response;
            console.log(response);
            // Afficher le modal ici si nécessaire
        }
    } catch (error) {
        console.error("Une erreur s'est produite lors de la récupération des données :", error);
    }
};

const getPreviousPage = async () => {
    try {
        const response = await $fetch(lesPresents.value.pagination.prev_page_url, {
            headers: {
                'Authorization': 'Bearer ' + token.value
            }
        });

        if (response) {
            lesPresents.value = response;
        }
    } catch (error) {
        console.error("Une erreur s'est produite lors de la récupération des données de la page précédente :", error);
    }
};

const getNextPage = async () => {
    try {
        const response = await $fetch(lesPresents.value.pagination.next_page_url, {
            headers: {
                'Authorization': 'Bearer ' + token.value
            }
        });

        if (response) {
            lesPresents.value = response;
        }
    } catch (error) {
        console.error("Une erreur s'est produite lors de la récupération des données de la page suivante :", error);
    }
};


</script>
<template>
    <nav class="p-4 md:py-8 xl:px-0 md:container md:mx-w-6xl md:mx-auto">
        <div class="hidden lg:flex lg:justify-between lg:items-center">
            <a href="#" class="flex items-start gap-2 group">
                <div class="bg-transparent text-white p-2 rounded-md group-hover:bg-blue-800">
                    <ElementsIconsLogo />
                </div>
                <p class="text-sm font-light uppercase">
                    Dashboard
                    <span class="text-base block font-bold tracking-widest">
                        EventPass
                    </span>
                </p>
            </a>

            <ul class="flex space-x-2 xl:space-x-4 text-sm font-semibold">
                <li>
                    <a href="#">
                        <div class="p-2 rounded hover:bg-gray-200 dark:hover:bg-gray-600">
                            <svg xmlns="http://www.w3.org/2000/svg"
                                class="w-4 h-4 stroke-current text-gray-800 dark:text-gray-300" fill="none"
                                viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                            </svg>
                        </div>
                    </a>
                </li>
                <li>
                    <a href="#">
                        <div class="p-2 rounded hover:bg-gray-200 dark:hover:bg-gray-600">
                            <svg xmlns="http://www.w3.org/2000/svg"
                                class="w-4 h-4 stroke-current text-gray-800 dark:text-gray-300" fill="none"
                                viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                            </svg>
                        </div>
                    </a>
                </li>
                <li>
                    <a href="#">
                        <div class="p-2 rounded hover:bg-gray-200 dark:hover:bg-gray-600">
                            <svg xmlns="http://www.w3.org/2000/svg"
                                class="w-4 h-4 stroke-current text-gray-800 dark:text-gray-300" fill="none"
                                viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
                            </svg>
                        </div>
                    </a>
                </li>
            </ul>

            <ul class="flex items-center gap-6">
                <li>
                    <ElementsThemeSwitcher />
                </li>
                <li>
                    <a href="#" class="text-sm font-sans text-gray-800 dark:text-gray-300 font-semibold tracking-wider">
                        {{ users.data.value.firstname }}
                    </a>
                </li>
                <li>
                    <a @click="logout()" href="#">
                        <div class="p-2 rounded hover:bg-gray-200 dark:hover:bg-gray-600">
                            <svg xmlns="http://www.w3.org/2000/svg"
                                class="w-5 h-5 stroke-current text-gray-800 dark:text-gray-300" fill="none"
                                viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                            </svg>
                        </div>
                    </a>
                </li>
            </ul>
        </div>
        <div x-data="{ open: false }" class="lg:hidden relative flex justify-between w-full">
            <div class="flex">
                <div class="w-1/2">
                    <!-- Contenu du div de gauche -->
                    <a href="#" class="flex items-start gap-2 group">
                        <div class="bg-blue-600 text-white p-3 rounded-md group-hover:bg-blue-800">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                            </svg>
                        </div>
                        <p class="text-sm font-light uppercase">
                            Dashboard
                            <span class="text-base block font-bold tracking-widest">
                                Atom
                            </span>
                        </p>
                    </a>
                </div>
                <div class="w-1/2 text-right ml-80">
                    <!-- Contenu du div de droite -->
                    <ul class="flex space-x-2 xl:space-x-4 text-sm font-semibold ml-40">
                        <li>
                            <ElementsThemeSwitcher />
                        </li>
                        <li
                            class="mt-5 text-sm font-sans text-gray-800 dark:text-gray-300 font-semibold tracking-wider">
                            <button> {{ users.data.value.name }} </button>
                        </li>
                        <li class="mt-3">
                            <a @click="logout()" href="#">
                                <div class="p-2 rounded hover:bg-gray-200 dark:hover:bg-gray-600">
                                    <svg xmlns="http://www.w3.org/2000/svg"
                                        class="w-5 h-5 stroke-current text-gray-800 dark:text-gray-300" fill="none"
                                        viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                                    </svg>
                                </div>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>


            <!-- Mobile menu button -->


        </div>
    </nav>
    <!-- End Nav -->
    <!-- Start Main -->
    <main class="container mx-w-6xl mx-auto py-4">
        <!-- modal statistique event terminer -->
        <dialog id="modalPresent" class="modal">
            <form method="dialog" class="modal-box w-11/12 max-w-5xl">
                <h3 class="font-bold text-lg">La liste de tout ceux qui sont venus</h3>

                <ul class="max-w-50 divide-y divide-gray-200 dark:divide-gray-700">
                    <li v-if="lesPresents" v-for="(presen, id) in lesPresents.data" :key="id" class="py-3 sm:py-4">
                        <div class="flex items-center space-x-4 rtl:space-x-reverse">

                            <div class="flex-1 min-w-0">
                                <p class="text-sm font-medium text-gray-900 truncate dark:text-white">
                                    {{ presen.firstname }} {{ presen.lastname }}
                                </p>
                                <p class="text-sm text-gray-500 truncate dark:text-gray-400">
                                    {{ presen.email }}
                                </p>
                            </div>
                            <div class="inline-flex items-center text-base font-semibold text-gray-900 dark:text-white">
                                {{ presen.phone }}
                            </div>
                        </div>
                    </li>

                </ul>
                <div class="flex flex-row mx-auto">
                    <button type="button" @click="getPreviousPage()"
                        class="bg-gray-800 text-white rounded-l-md border-r border-gray-100 py-2 hover:bg-red-700 hover:text-white px-3">
                        <div class="flex flex-row align-middle">
                            <svg class="w-5 mr-2" fill="currentColor" viewBox="0 0 20 20"
                                xmlns="http://www.w3.org/2000/svg">
                                <path fill-rule="evenodd"
                                    d="M7.707 14.707a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l2.293 2.293a1 1 0 010 1.414z"
                                    clip-rule="evenodd"></path>
                            </svg>
                            <p class="ml-2">Prev</p>
                        </div>
                    </button>
                    <button type="button" @click="getNextPage()"
                        class="bg-gray-800 text-white rounded-r-md py-2 border-l border-gray-200 hover:bg-red-700 hover:text-white px-3">
                        <div class="flex flex-row align-middle">
                            <span class="mr-2">Next</span>
                            <svg class="w-5 ml-2" fill="currentColor" viewBox="0 0 20 20"
                                xmlns="http://www.w3.org/2000/svg">
                                <path fill-rule="evenodd"
                                    d="M12.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-2.293-2.293a1 1 0 010-1.414z"
                                    clip-rule="evenodd"></path>
                            </svg>
                        </div>
                    </button>
                </div>


                <div class="modal-action">

                    <!-- if there is a button, it will close the modal -->
                    <button class="btn">Fermer</button>
                </div>
            </form>
        </dialog>
        <!-- fin modal event terrminer -->

        <!-- Modal creation  event -->

        <dialog id="create" class="modal mr-60">
            <form method="dialog" class="modal-box ">
                <button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">✕</button>
                <form>
                    <h6 class="text-lg font-bold dark:text-white mb-7">Créer un événement</h6>
                    <div class="relative z-0 w-full mb-6 group">
                        <input type="text" name="floating_email" id="floating_email" v-model="sam.titre"
                            class="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                            placeholder=" " required />
                        <label for="floating_email"
                            class="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">Titre
                        </label>
                    </div>
                    <div class="relative z-0 w-full mb-6 group">
                        <input type="text" name="floating_first_name" id="floating_first_name" v-model="sam.lieu"
                            class="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                            placeholder=" " required />
                        <label for="floating_first_name"
                            class="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                            Lieu</label>
                    </div>

                    <div class="grid md:grid-cols-2 md:gap-6">
                        <div class="relative z-0 w-full mb-6 group">
                            <input type="date" name="floating_first_name" id="floating_first_name" v-model="sam.date"
                                class="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                placeholder=" " required />
                            <label for="floating_first_name"
                                class="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                Date</label>
                        </div>
                        <div class="relative z-0 w-full mb-6 group">
                            <input type="time" name="floating_last_name" id="floating_last_name" v-model="sam.heure"
                                class="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                placeholder=" " required />
                            <label for="floating_last_name"
                                class="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                Heure</label>
                        </div>
                    </div>

                    <div class="relative z-0 w-full mb-6 group">
                        <input type="text" name="floating_password" id="floating_password" v-model="sam.description"
                            class="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                            placeholder=" " required />
                        <label for="floating_password"
                            class="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">Description</label>
                    </div>

                    <div class="flex-1 p-4">
                        <button type="button" @click="creerEvent()"
                            class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm w-full sm:w-auto px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">Créer
                            un événement </button>
                    </div>
                </form>

                <div class="modal-action">
                    <!-- if there is a button, it will close the modal -->
                    <!-- <button class="btn">Close</button> -->
                </div>
            </form>
        </dialog>

        x


        <!-- fin modal creation event -->


        <!-- Modal details Event -->
        <dialog id="detail" class="modal">
            <form method="dialog" class="modal-box w-11/12 max-w-2xl">
                <button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">✕</button>

                <form>
                    <div class="flex">
                        <div class="w-1/2 p-4">
                            <h6 class="text-lg font-bold dark:text-white mb-7">Details d'un Evenement</h6>
                        </div>
                        <div class="w-1/2 p-4">
                            <button
                                class="group relative h-10 w-60 overflow-hidden rounded-lg bg-white text-base shadow">
                                <div
                                    class="absolute inset-0 w-2 bg-gray-400 transition-all duration-250 ease-out group-hover:w-full">
                                </div>
                                <span class=" px-1 relative text-black group-hover:text-white"> Inviter tout le monde
                                </span>
                            </button>
                        </div>

                    </div>


                    <div class="relative z-0 w-full mb-6 group">
                        <input type="text" name="floating_email" id="floating_email" v-if="detailEvent"
                            v-model="detailEvent.titre"
                            class="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                            placeholder=" " required />
                        <label for="floating_email"
                            class="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">Titre
                        </label>
                    </div>
                    <div class="relative z-0 w-full mb-6 group">
                        <input type="text" name="repeat_password" id="floating_repeat_password" v-if="detailEvent"
                            v-model="detailEvent.lieu"
                            class="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                            placeholder=" " required />
                        <label for="floating_repeat_password"
                            class="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                            Lieu</label>
                    </div>
                    <div class="grid md:grid-cols-2 md:gap-6">
                        <div class="relative z-0 w-full mb-6 group">
                            <input type="date" name="floating_first_name" id="floating_first_name" v-if="detailEvent"
                                v-model="detailEvent.date"
                                class="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                placeholder=" " required />
                            <label for="floating_first_name"
                                class="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                Date</label>
                        </div>
                        <div class="relative z-0 w-full mb-6 group">
                            <input type="time" name="floating_last_name" id="floating_last_name" v-if="detailEvent"
                                v-model="detailEvent.heure"
                                class="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                placeholder=" " required />
                            <label for="floating_last_name"
                                class="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">
                                Heure</label>
                        </div>
                    </div>

                    <div class="relative z-0 w-full mb-6 group">
                        <input type="text" name="floating_password" id="floating_password" v-if="detailEvent"
                            v-model="detailEvent.description"
                            class="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                            placeholder=" " required />
                        <label for="floating_password"
                            class="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">Description</label>
                    </div>

                    <div class="flex">
                        <div class="flex-1">
                            <button type="button" @click="mettreAjour(detailEvent.id)"
                                class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm w-full sm:w-auto px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">Mettre
                                a jour </button>
                        </div>
                        <div class="flex-1">
                            <button @click="getPresent(detailEvent.id)"
                                class="mr-6 text-emerald-500 bg-transparent border border-solid border-emerald-500 hover:bg-emerald-500 hover:text-white active:bg-emerald-600 font-bold uppercase text-xs px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
                                type="button">
                                <i class="fas fa-heart"></i> Participants Present
                            </button>
                        </div>
                        <div class="flex-1">
                            <button
                                class="mr-6 text-emerald-500 bg-transparent border border-solid border-emerald-500 hover:bg-emerald-500 hover:text-white active:bg-emerald-600 font-bold uppercase text-xs px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
                                type="button">
                                <i class="fas fa-heart"></i> Participants Absent
                            </button>
                        </div>
                        <div class="flex-1">
                            <button
                                class="mr-6 text-emerald-500 bg-transparent border border-solid border-emerald-500 hover:bg-emerald-500 hover:text-white active:bg-emerald-600 font-bold uppercase text-xs px-4 py-2 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
                                type="button">
                                <i class="fas fa-heart"></i> Participants Sans-contre-Scan
                            </button>
                        </div>


                    </div>
                </form>
            </form>
        </dialog>

        <!-- fin modal details Event -->

        <div class="flex flex-col space-y-8">

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 px-4 xl:p-0 gap-4 xl:gap-6">
                <div class="col-span-1 md:col-span-2 lg:col-span-4 flex justify-between">
                    <h2 class="text-xs md:text-sm text-gray-800 dark:text-gray-300 font-bold tracking-wide">
                        Aperçu du tableau de bord
                    </h2>


                </div>
                <div class="p-6 rounded-xl border border-gray-50 dark:bg-gray-800 dark:border-none">

                    <div class="flex justify-between items-start">
                        <div class="flex flex-col">
                            <p class="text-xs text-gray-600 tracking-wide">Nombre d'Evenements </p>
                            <h3 class="mt-1 text-lg text-blue-500 font-bold">{{ nbEventTotal.data.value }}</h3>
                            <!-- <span class="mt-4 text-xs text-gray-500">Last Transaction 3 Hours ago</span> -->
                        </div>
                    </div>
                </div>
                <div class="p-6 rounded-xl border border-gray-50 dark:bg-gray-800 dark:border-none">
                    <!-- <div class="flex justify-between items-start">
                        <div class="flex flex-col">
                            <p class="text-xs text-gray-600 tracking-wide">Nombre d'événements terminés</p>
                            <h3 class="mt-1 text-lg text-yellow-500 font-bold">{{ nbEventTerminer.data.value }}</h3>
                        </div>
                    </div> -->
                </div>
                <div class="p-6 rounded-xl border border-gray-50 dark:bg-gray-800 dark:border-none">
                    <div class="flex justify-between items-start">
                        <!-- <div class="flex flex-col">
                            <p class="text-xs text-gray-600 tracking-wide">Mon chiffre d'affaires total </p>
                            <h3 class="mt-1 text-lg text-indigo-500 font-bold">{{ RevenusTotal }} Ar</h3>
                        </div> -->
                    </div>
                </div>
                <div class="p-6 rounded-xl border border-gray-50 dark:bg-gray-800 dark:border-none">
                    <div class="flex justify-between items-start">
                        <div class="flex flex-col">
                            <p class="text-xs text-gray-600 tracking-wide">Mes pharmaciens</p>
                            <h3 class="mt-1 text-lg text-green-500 font-bold">{{ nbUsers.data.value }}</h3>
                        </div>
                    </div>
                </div>
            </div>
            <!-- End Second Row -->
            <!-- Start Third Row -->
            <div class="grid grid-cols-1 md:grid-cols-5 items-start px-4 xl:p-0 gap-y-4 md:gap-6">
                <div class="col-start-1 col-end-5">
                    <div class="flex">
                        <div class="w-1/2">
                            <!-- Contenu du div de gauche -->

                            <h2 class="text-xs md:text-sm text-gray-800 dark:text-gray-300 font-bold tracking-wide">
                                Les événements
                            </h2>
                        </div>
                        <div class="w-1/2 ml-80">
                            <!-- Contenu du div de droite -->
                            <button type="button" onclick="create.showModal()"
                                class="text-white bg-[#2557D6] hover:bg-[#2557D6]/90 focus:ring-4 focus:ring-[#2557D6]/50 focus:outline-none font-medium rounded-lg text-sm px-5 py-2.5 text-center inline-flex items-center dark:focus:ring-[#2557D6]/50 mr-2 mb-2">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                                    stroke-width="1.5" stroke="currentColor" class="w-6 h-6 m">
                                    <path stroke-linecap="round" stroke-linejoin="round"
                                        d="M14.25 6.087c0-.355.186-.676.401-.959.221-.29.349-.634.349-1.003 0-1.036-1.007-1.875-2.25-1.875s-2.25.84-2.25 1.875c0 .369.128.713.349 1.003.215.283.401.604.401.959v0a.64.64 0 01-.657.643 48.39 48.39 0 01-4.163-.3c.186 1.613.293 3.25.315 4.907a.656.656 0 01-.658.663v0c-.355 0-.676-.186-.959-.401a1.647 1.647 0 00-1.003-.349c-1.036 0-1.875 1.007-1.875 2.25s.84 2.25 1.875 2.25c.369 0 .713-.128 1.003-.349.283-.215.604-.401.959-.401v0c.31 0 .555.26.532.57a48.039 48.039 0 01-.642 5.056c1.518.19 3.058.309 4.616.354a.64.64 0 00.657-.643v0c0-.355-.186-.676-.401-.959a1.647 1.647 0 01-.349-1.003c0-1.035 1.008-1.875 2.25-1.875 1.243 0 2.25.84 2.25 1.875 0 .369-.128.713-.349 1.003-.215.283-.4.604-.4.959v0c0 .333.277.599.61.58a48.1 48.1 0 005.427-.63 48.05 48.05 0 00.582-4.717.532.532 0 00-.533-.57v0c-.355 0-.676.186-.959.401-.29.221-.634.349-1.003.349-1.035 0-1.875-1.007-1.875-2.25s.84-2.25 1.875-2.25c.37 0 .713.128 1.003.349.283.215.604.401.96.401v0a.656.656 0 00.658-.663 48.422 48.422 0 00-.37-5.36c-1.886.342-3.81.574-5.766.689a.578.578 0 01-.61-.58v0z" />
                                </svg>
                                Créer un événement
                            </button>
                        </div>
                    </div>
                </div>
                <!-- <div
                    class="col-span-2 bg-white dark:bg-gray-800 p-6 rounded-xl border border-gray-50 dark:border-gray-700 flex flex-col space-y-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 flex justify-between items-center">
                        <div class="p-4 cursor-pointer border dark:border-gray-600">
                            <span class="text-xs text-gray-500 dark:text-gray-400 font-semibold">Quotidien</span>
                            <h2 class="text-gray-800 dark:text-gray-300 font-bold tracking-wider">$ 27.80</h2>
                        </div>
                        <div class="p-4 cursor-pointer border dark:border-gray-600">
                            <span class="text-xs text-gray-500 dark:text-gray-400 font-semibold">Hebdomadaire</span>
                            <h2 class="text-gray-800 dark:text-gray-300 font-bold tracking-wider">$ 192.92</h2>
                        </div>
                        <div class="p-4 cursor-pointer border dark:border-gray-600">
                            <span class="text-xs text-gray-500 dark:text-gray-400 font-semibold">Mensuel</span>
                            <h2 class="text-gray-800 dark:text-gray-300 font-bold tracking-wider">$ 501.10</h2>
                        </div>
                    </div>

                    <Bar :data="data" :options="options" />
                </div> -->
            </div>
            <!-- End Third Row -->

            <div
                class="col-span-3 bg-white dark:bg-gray-800 p-6 rounded-xl border border-gray-50 flex flex-col space-y-6 dark:border-none">

                <div class="flex justify-between items-center">
                    <h2 class="text-sm text-gray-600 dark:text-gray-400 font-bold tracking-wide">Les événements
                    </h2>


                </div>

                <div class="relative overflow-x-auto shadow-md sm:rounded-lg">
                    <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
                        <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
                            <tr>
                                <th scope="col" class="px-6 py-3">
                                    Titre
                                </th>
                                <th scope="col" class="px-6 py-3">
                                    Heure
                                </th>
                                <th scope="col" class="px-6 py-3">
                                    date
                                </th>
                                <th scope="col" class="px-6 py-3">
                                    Prix
                                </th>
                                <th scope="col" class="px-6 py-3">
                                    <span class="sr-only">Consulter</span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-if="EventEncours" v-for="cour in EventEncours.data"
                                class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600">
                                <th scope="row"
                                    class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                    {{ cour.titre }}
                                </th>
                                <td class="px-6 py-4">
                                    {{ cour.heure }}
                                </td>
                                <td class="px-6 py-4">
                                    {{ cour.date }}
                                </td>
                                <td class="px-6 py-4">
                                    {{ cour.lieu }}
                                </td>
                                <td class="px-6 py-4 text-right">
                                    <a @click="oneEvent(cour.id)" href="#"
                                        class="font-medium text-blue-600 dark:text-blue-500 hover:underline">Consulter</a>
                                </td>
                            </tr>

                        </tbody>
                    </table>
                    <!-- bouton next et prev  -->
                    <div class="flex flex-row mx-auto mt-5">
                        <button type="button" @click="getPreviousEvents()"
                            class="bg-gray-800 text-white rounded-l-md border-r border-gray-100 py-2 hover:bg-red-700 hover:text-white px-3">
                            <div class="flex flex-row align-middle">
                                <svg class="w-5 mr-2" fill="currentColor" viewBox="0 0 20 20"
                                    xmlns="http://www.w3.org/2000/svg">
                                    <path fill-rule="evenodd"
                                        d="M7.707 14.707a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l2.293 2.293a1 1 0 010 1.414z"
                                        clip-rule="evenodd"></path>
                                </svg>
                                <p class="ml-2">Prev</p>
                            </div>
                        </button>
                        <button type="button" @click="getNextEvents()"
                            class="bg-gray-800 text-white rounded-r-md py-2 border-l border-gray-200 hover:bg-red-700 hover:text-white px-3">
                            <div class="flex flex-row align-middle">
                                <span class="mr-2">Next</span>
                                <svg class="w-5 ml-2" fill="currentColor" viewBox="0 0 20 20"
                                    xmlns="http://www.w3.org/2000/svg">
                                    <path fill-rule="evenodd"
                                        d="M12.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-2.293-2.293a1 1 0 010-1.414z"
                                        clip-rule="evenodd"></path>
                                </svg>
                            </div>
                        </button>
                    </div>
                </div>

            </div>
            <div
                class="col-span-3 w-90 bg-white dark:bg-gray-800 p-6 rounded-xl border border-gray-50 flex flex-col space-y-6 dark:border-none">


                <div class="flex justify-between items-center">
                    <h2 class="text-sm text-gray-600 dark:text-gray-400 font-bold tracking-wide">Tous les
                        pharmaciens
                    </h2>
                </div>

                <div class="relative overflow-x-auto shadow-md sm:rounded-lg">
                    <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
                        <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
                            <tr>
                                <th scope="col" class="px-6 py-3">
                                    Firstname
                                </th>
                                <th scope="col" class="px-6 py-3">
                                    Lastname
                                </th>
                                <th scope="col" class="px-6 py-3">
                                    Email
                                </th>
                                <th scope="col" class="px-6 py-3">
                                    Phone
                                </th>
                                <th></th>

                            </tr>
                        </thead>
                        <tbody>
                            <tr v-if="all" v-for="dean in all.data"
                                class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600">
                                <th scope="row"
                                    class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                    {{ dean.firstname }}
                                </th>
                                <td class="px-6 py-4">
                                    {{ dean.lastname }}
                                </td>
                                <td class="px-6 py-4">
                                    {{ dean.email }}
                                </td>
                                <td class="px-6 py-4">
                                    {{ dean.phone }}
                                </td>
                                <td class="px-6 py-4 text-right">
                                    <a href="#"
                                        class="font-medium text-blue-600 dark:text-blue-500 hover:underline">Consulter</a>
                                </td>
                            </tr>

                        </tbody>
                    </table>

                    <div class="flex flex-row mx-auto mt-5">
                        <button type="button" @click="getPreviousEventsAll()"
                            class="bg-gray-800 text-white rounded-l-md border-r border-gray-100 py-2 hover:bg-red-700 hover:text-white px-3">
                            <div class="flex flex-row align-middle">
                                <svg class="w-5 mr-2" fill="currentColor" viewBox="0 0 20 20"
                                    xmlns="http://www.w3.org/2000/svg">
                                    <path fill-rule="evenodd"
                                        d="M7.707 14.707a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l2.293 2.293a1 1 0 010 1.414z"
                                        clip-rule="evenodd"></path>
                                </svg>
                                <p class="ml-2">Prev</p>
                            </div>
                        </button>
                        <button type="button" @click="getNextEventsAll()"
                            class="bg-gray-800 text-white rounded-r-md py-2 border-l border-gray-200 hover:bg-red-700 hover:text-white px-3">
                            <div class="flex flex-row align-middle">
                                <span class="mr-2">Next</span>
                                <svg class="w-5 ml-2" fill="currentColor" viewBox="0 0 20 20"
                                    xmlns="http://www.w3.org/2000/svg">
                                    <path fill-rule="evenodd"
                                        d="M12.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-2.293-2.293a1 1 0 010-1.414z"
                                        clip-rule="evenodd"></path>
                                </svg>
                            </div>
                        </button>
                    </div>

                </div>


            </div>
        </div>
    </main>
    <!-- End Main -->
</template>
<script>
import {
    Chart as ChartJS,
    Title,
    Tooltip,
    Legend,
    BarElement,
    CategoryScale,
    LinearScale
} from 'chart.js'
import { Bar } from 'vue-chartjs'

ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend)

export default {
    name: 'App',
    components: {
        Bar
    },
    data() {
        return {
            //les données du graphique : nombre event en cours  , terminer ,  et total
            id: 0,
            data: {
                labels: ['Event en cours', 'Event terminer', 'Total'],
                datasets: [{
                    label: 'Nombre d\'evenement',
                    data: [12, 2, 14],
                    backgroundColor: [
                        '#3B82F6',
                        '#10B981',
                        '#F59E0B'
                    ],
                    borderColor: [
                        '#3B82F6',
                        '#10B981',
                        '#F59E0B'
                    ],
                    borderWidth: 1
                }]
            },
        }
    },
    mounted() {
        this.getUserId()
    },
    methods: {
        async getUserId() {
            this.data.datasets[0].data = [
                5,
                5,
                5
            ];

            // Refresh the chart
            this.renderChart(this.data, this.options);
        },
        async getEventData() {
            let token = useCookie("token")
            let id = await $fetch(`${uri}user`, {
                headers: {
                    'Authorization': 'Bearer ' + token.value

                }
            });
            try {
                const responseEncours = await $fetch(`${uri}eventEncoursCount/${id.id}`, {
                    headers: {
                        'Authorization': 'Bearer ' + token.value

                    }
                });
                const responseTerminer = await $fetch(`${uri}eventOverCount/${id.id}`, {
                    headers: {
                        'Authorization': 'Bearer ' + token.value

                    }
                });
                const responseAll = await $fetch(`${uri}all`, {
                    headers: {
                        'Authorization': 'Bearer ' + token.value

                    }
                });
                console.log(responseEncours);


                this.data.datasets[0].data = [
                    responseEncours,
                    responseTerminer,
                    responseAll
                ];

                // Refresh the chart
                this.renderChart(this.data, this.options);
            } catch (error) {
                console.error('Error fetching data:', error);
            }
        }
    }
}
</script>