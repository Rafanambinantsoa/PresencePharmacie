<script setup>
import Swal from 'sweetalert2'
import { uri } from '~/stores/uri';

console.log(uri);
const token = useCookie("token")

useHead({
    title: 'EventPass - Admin',
    meta: [
        { name: 'description', content: 'Podux Podcast landing page website.' },
    ],
    link: [
        { rel: 'icon', type: 'image/png', href: '/logo.png' }
    ],
})

onMounted(() => {
    fetchInitialBill()
})

//Pagination les compte utilisateurs 
const bill = ref([]);

const getNextBill = async () => {
    if (!bill.value.next_page_url) return;
    const response = await $fetch(bill.value.next_page_url, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    });
    bill.value = response;
    // fetchInitialData()

};

const getPreviousBill = async () => {
    if (!bill.value.prev_page_url) return;
    const response = await $fetch(bill.value.prev_page_url, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    });
    bill.value = response;
};

// Récupérer les données initiales
const fetchInitialBill = async () => {
    const response = await $fetch(`${uri}userNon/${users.data.value.id}`, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    });
    bill.value = response;
};

// //Les compte en cours de demande des Utilisateurs
// const { data: bill } = await useAsyncData("mi", () =>
//     $fetch(`${uri}userNon`, {
//         headers: {
//             'Authorization': 'Bearer ' + token.value
//         }
//     })
// );

//Les comptes valide des Utilisateurs
const { data: valideUser } = await useAsyncData("valide", () =>
    $fetch(`${uri}userValide`, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    })
);

// const bill = nonValide.value;

//Pour afficher tous les comptes 
const { data: allCompte } = await useAsyncData("all", () =>
    $fetch(`${uri}user/all`, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    })
);

//Tous les clients  
const { data: allClient } = await useAsyncData("allClient", () =>
    $fetch(`${uri}client/all`, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    })
);


//Pour rafraichir le donnee UserNon
const refresh = () => refreshNuxtData("mi")

//Pour rafraichir le donnee UserValide
const refreshValide = () => refreshNuxtData("valide")

//Pour rafraichir le donnee allcompte
const refreshAll = () => refreshNuxtData("all")



//Pour rejeter un utilisateur
const rejetOrganisateur = (id) => {
    Swal.fire({
        title: 'Veuillez patienter ...',
        allowOutsideClick: false,
        allowEscapeKey: false,
        allowEnterKey: false,
        didOpen: () => {
            Swal.showLoading()
        }
    });
    useFetch(`${uri}user/delete/${id}`, {
        method: 'DELETE',
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    }).then(() => {
        Swal.close()
        refresh()
        refreshValide()
        refreshAll()

    })
}

//Pour accepter un utilisateur
const acceptOrganisateur = (id) => {
    Swal.fire({
        title: 'Veuillez patienter ...',
        allowOutsideClick: false,
        allowEscapeKey: false,
        allowEnterKey: false,
        didOpen: () => {
            Swal.showLoading()
        }
    });
    useFetch(`${uri}validate/${id}`, {
        method: 'PATCH',
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    }).then(() => {
        Swal.close()
        refresh()
        refreshValide()
        refreshAll()

    })
}

//Pour bloquer un compte
const blocker = (id) => {
    Swal.fire({
        title: 'Veuillez patienter ...',
        allowOutsideClick: false,
        allowEscapeKey: false,
        allowEnterKey: false,
        didOpen: () => {
            Swal.showLoading()
        }
    });
    useFetch(`${uri}block/${id}`, {
        method: 'PATCH',
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    }).then((res) => {
        Swal.close()
        refreshAll()
        refreshValide()
        console.log("Locked");
    })
}

//Pour debloquer un compte
const deblocker = (id) => {
    Swal.fire({
        title: 'Veuillez patienter ...',
        allowOutsideClick: false,
        allowEscapeKey: false,
        allowEnterKey: false,
        didOpen: () => {
            Swal.showLoading()
        }
    });
    useFetch(`${uri}deblock/${id}`, {
        method: 'PATCH',
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    }).then((res) => {
        Swal.close()
        refreshAll()
        refreshValide()
        console.log("Unlocked");
    })
}

//Nombre d'Evenment total
const nbEvent = await useAsyncData("nbEvent", () =>
    $fetch(`${uri}eventCount`, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    })
);

//Nombre d'client total
const nbClient = await useAsyncData("nbClient", () =>
    $fetch(`${uri}client/count`, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    })
);

//Revenus total
const revenus = await useAsyncData("revenus", () =>
    $fetch(`${uri}commande/montantTotal`, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    })
);

//Nombre d'Organisateurs total
const nbOrgan = await useAsyncData("nbOrgan", () =>
    $fetch(`${uri}organisateur/count`, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    })
);


//Nom admin
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


import { ref } from 'vue';

// Créez une référence pour stocker les données récupérées depuis l'API
const donnee = ref(null);

async function oneUser(id) {
    try {
        // Utilisez la méthode $fetch de Nuxt.js pour récupérer les données depuis l'API
        const response = await $fetch(`${uri}user/${id}`, {
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

const organ = ref(null);


async function oneOrganisateur(id) {
    try {
        // Utilisez la méthode $fetch de Nuxt.js pour récupérer les données depuis l'API
        const response = await $fetch(`${uri}infoOrgan/${id}`, {
            headers: {
                'Authorization': 'Bearer ' + token.value
            }
        });

        // Vérifiez si la réponse a réussi et stockez les données dans la référence 'donee'
        if (response) {
            organ.value = response;
            modalInfoOrgan.showModal();
            console.log(response);
            // Affichez les données dans la console pour vérifier si tout fonctionne correctement
            // Affichez le modal avec les données récupérées
        }
    } catch (error) {
        console.error("Une erreur s'est produite lors de la récupération des données :", error);
    }
}

</script>
<template>

    <dialog id="modalInfoOrgan" class="modal">
        <div class="flex font-sans">
        </div>
        <form method="dialog" class="modal-box w-11/12 max-w-5xl h-auto">
            <button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">✕</button>
            <!-- Utilisez la directive v-if pour conditionner l'affichage des données -->
            <div v-if="organ">
                <div class="flex">
                    <div class="w-1/2 p-4">
                        <!-- Ajoutez une condition pour afficher l'image uniquement si elle est disponible -->
                        <h3 v-if="organ.nom">Les inforamtion de l'Organisateurs : <br> {{ organ.nom }} </h3>
                    </div>
                    <div class="w-1/2 bg-auto-200 p-4">
                        <p v-if="organ" class="mb-4"> <span> Revenus : </span> {{ organ.revenus }} Ar </p>
                        <p v-if="organ" class="mb-4"> <span> Ces evenements : </span> {{ organ.nbEvent }} </p>
                    </div>
                </div>
            </div>
            <!-- Ajoutez une condition pour afficher un message si les données ne sont pas encore disponibles -->
            <div v-else>
                Chargement des données...
            </div>
        </form>
    </dialog>

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
                        <img class="bg-cover h-60 w-80" :src="`${uri}` + donnee.imageJustificatif" alt="">
                    </div>
                    <div class="w-1/2 bg-auto-200 p-4">
                        <h3 v-if="donnee.titre"> {{ donnee.name }} </h3>

                        <p v-if="donnee.email" class="mb-4"> <span> Email : </span> {{ donnee.email }} </p>
                        <p v-if="donnee.email" class="mb-4"> <span> Nom : </span> {{ donnee.name }} </p>
                        <p v-if="donnee.role" class="mb-4"> <span> Son Role : </span> {{ donnee.role }} </p>
                    </div>
                </div>
            </div>
            <!-- Ajoutez une condition pour afficher un message si les données ne sont pas encore disponibles -->
            <div v-else>
                Chargement des données...
            </div>
        </form>
    </dialog>



    <!-- Modal confirm  -->
    <dialog id="declineUser" class="modal">
        <form method="dialog" class="modal-box">
            <h3 class="font-bold text-lg">Hello!</h3>
            <p class="py-4">Are you sure to disapprouve this request ?</p>
            <div class="text-right">
                <button>Yes</button><button class="ml-6">Cancel</button>
            </div>
        </form>
        <form method="dialog" class="modal-backdrop">
            <button>close</button>
        </form>
    </dialog>

    <!-- <div class="fixed bottom-4 right-4 xl:right-20">
        <a href="https://www.buymeacoffee.com/ejulfaey" target="_blank"
            class="transform duration-500 ease-in-out animate-bounce bg-yellow-400 px-4 py-3 font-mono font-semibold rounded-lg shadow hover:shadow-xl flex justify-between items-center gap-4">
            <img class="w-8 h-8 rounded"
                src="https://img.buymeacoffee.com/api/?name=Ejul&size=300&bg-image=bmc&background=5F7FFF"
                alt="buymeacoffee">
            Buy Me A Coffee
        </a>
    </div> -->
    <nav class="p-4 md:py-8 xl:px-0 md:container md:mx-w-6xl md:mx-auto">
        <div class="hidden lg:flex lg:justify-between lg:items-center">
            <a href="#" class="flex items-start gap-2 group">
                <div class="bg-transparent-600 text-white p-2">
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
                        {{ users.data.value.name }}
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
                            <a href="#">{{ users.data.value.name }}</a>
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
        <div class="flex flex-col space-y-8">

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 px-4 xl:p-0 gap-4 xl:gap-6">
                <div class="col-span-1 md:col-span-2 lg:col-span-4 flex justify-between">
                    <h2 class="text-xs md:text-sm text-gray-800 dark:text-gray-300 font-bold tracking-wide">Dépenses par
                        Catégorie
                    </h2>


                </div>
                <div class="p-6 rounded-xl border border-gray-50 dark:bg-gray-800 dark:border-none">

                    <div class="flex justify-between items-start">
                        <div class="flex flex-col">
                            <p class="text-xs text-gray-600 tracking-wide">Nombre des Clients</p>
                            <h3 class="mt-1 text-lg text-blue-500 font-bold"> {{ nbClient.data }}</h3>
                            <!-- <span class="mt-4 text-xs text-gray-500">Last Transaction 3 Hours ago</span> -->
                        </div>
                    </div>
                </div>
                <div class="p-6 rounded-xl border border-gray-50 dark:bg-gray-800 dark:border-none">
                    <div class="flex justify-between items-start">
                        <div class="flex flex-col">
                            <p class="text-xs text-gray-600 tracking-wide">Organisateurs Disponible</p>
                            <h3 class="mt-1 text-lg text-green-500 font-bold">{{ nbOrgan.data }}</h3>
                        </div>
                    </div>
                </div>
                <div class="p-6 rounded-xl border border-gray-50 dark:bg-gray-800 dark:border-none">
                    <div class="flex justify-between items-start">
                        <div class="flex flex-col">
                            <p class="text-xs text-gray-600 tracking-wide">Nombre des Event</p>
                            <h3 class="mt-1 text-lg text-yellow-500 font-bold"> {{ nbEvent.data }} </h3>
                        </div>
                    </div>
                </div>
                <div class="p-6 rounded-xl border border-gray-50 dark:bg-gray-800 dark:border-none">
                    <div class="flex justify-between items-start">
                        <div class="flex flex-col">
                            <p class="text-xs text-gray-600 tracking-wide">Tous les revenus : </p>
                            <h3 class="mt-1 text-lg text-indigo-500 font-bold"> {{ revenus.data }} ar</h3>
                        </div>
                    </div>
                </div>
            </div>
            <!-- End Second Row -->
            <!-- Start Third Row -->
            <div class="grid grid-cols-1 md:grid-cols-5 items-start px-4 xl:p-0 gap-y-4 md:gap-6">
                <div class="col-start-1 col-end-5">
                    <h2 class="text-xs md:text-sm text-gray-800 dark:text-gray-300 font-bold tracking-wide">
                        Organisateurs
                    </h2>
                </div>
                <div
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
                </div>
                <div
                    class="col-span-3 bg-white dark:bg-gray-800 p-6 rounded-xl border border-gray-50 flex flex-col space-y-6 dark:border-none">

                    <div class="flex justify-between items-center">
                        <h2 class="text-sm text-gray-600 dark:text-gray-400 font-bold tracking-wide">Compte
                            organisateurs en
                            cours</h2>


                    </div>

                    <div class="relative overflow-x-auto shadow-md sm:rounded-lg">
                        <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
                            <thead
                                class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
                                <tr>
                                    <th scope="col" class="px-6 py-3">
                                        Nom
                                    </th>
                                    <th scope="col" class="px-6 py-3">
                                        Email
                                    </th>
                                    <th colspan="2" scope="col" class="px-6 py-3 text-center">
                                        Operations
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr @click="oneUser(bi.id)"
                                    class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600"
                                    v-for="bi in bill.data">
                                    <th scope="row"
                                        class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                        {{ bi.name }}
                                    </th>
                                    <td class="px-6 py-4">
                                        {{ bi.email }}
                                    </td>
                                    <td class="px-6 py-4 text-right">
                                        <button class="btn btn-sm btn-circle btn-ghost"
                                            @click="rejetOrganisateur(bi.id)">
                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                                                stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                                                <path stroke-linecap="round" stroke-linejoin="round"
                                                    d="M9.75 9.75l4.5 4.5m0-4.5l-4.5 4.5M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                            </svg>


                                        </button>

                                    </td>
                                    <td class="px-6 py-4 text-right">
                                        <button class="btn btn-sm btn-circle btn-ghost"
                                            @click="acceptOrganisateur(bi.id)">
                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                                                stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                                                <path stroke-linecap="round" stroke-linejoin="round"
                                                    d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                            </svg>


                                        </button>

                                    </td>
                                </tr>

                            </tbody>
                        </table>
                    </div>

                    <div class="flex justify-between items-center">
                        <h2 class="text-sm text-gray-600 dark:text-gray-400 font-bold tracking-wide">Compte
                            organisateurs
                            valide</h2>
                    </div>

                    <div class="relative overflow-x-auto shadow-md sm:rounded-lg">
                        <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
                            <thead
                                class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
                                <tr>
                                    <th scope="col" class="px-6 py-3">
                                        Nom
                                    </th>
                                    <th scope="col" class="px-6 py-3">
                                        Email
                                    </th>
                                    <th scope="col" class="px-6 py-3 text-center">

                                    </th>
                                    <th scope="col" class="px-6 py-3">
                                        <span class="sr-only">Edit</span>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600"
                                    v-for="my in valideUser">
                                    <th scope="row"
                                        class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                        {{ my.name }}
                                    </th>
                                    <td class="px-6 py-4">
                                        {{ my.email }}
                                    </td>
                                    <td @click="oneOrganisateur(my.id)" class="px-6 py-4 text-right">
                                        <a href="#"
                                            class="font-medium text-blue-600 dark:text-blue-500 hover:underline">Consulter</a>
                                    </td>
                                </tr>

                            </tbody>
                        </table>
                    </div>

                </div>





            </div>
            <!-- End Third Row -->
            <div class="grid grid-cols-1 md:grid-cols-5 items-start px-4 xl:p-0 gap-y-4 md:gap-6">
                <div class="col-start-1 col-end-5">
                    <h2 class="text-xs md:text-sm text-gray-800 font-bold tracking-wide">Client </h2>
                </div>
                <div
                    class="col-span-2 bg-white dark:bg-gray-800 p-6 rounded-xl border border-gray-50 flex flex-col space-y-6 dark:border-none">

                    <div class="flex justify-between items-center">
                        <h2 class="text-sm text-gray-600 dark:text-gray-400 font-bold tracking-wide">Bloquer un Compte
                        </h2>
                    </div>
                    <div class="relative overflow-x-auto shadow-md sm:rounded-lg">
                        <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
                            <thead
                                class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
                                <tr>
                                    <th scope="col" class="px-6 py-3">
                                        Nom
                                    </th>
                                    <th scope="col" class="px-6 py-3">
                                        Operations
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600"
                                    v-for="pa in allCompte">
                                    <th scope="row"
                                        class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                        {{ pa.name }}
                                    </th>
                                    <td v-if="pa.status == false" class="px-6 py-4 text-center">
                                        <button @click="deblocker(pa.id)" class="btn btn-sm btn-circle btn-ghost"
                                            type="button">
                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                                                stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                                                <path stroke-linecap="round" stroke-linejoin="round"
                                                    d="M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 00-2.25-2.25H6.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z" />
                                            </svg>

                                        </button>
                                    </td>
                                    <td v-else class="px-6 py-4 text-center">
                                        <button @click="blocker(pa.id)" class="btn btn-sm btn-circle btn-ghost"
                                            type="button">
                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                                                stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                                                <path stroke-linecap="round" stroke-linejoin="round"
                                                    d="M13.5 10.5V6.75a4.5 4.5 0 119 0v3.75M3.75 21.75h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 00-2.25-2.25H3.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z" />
                                            </svg>

                                        </button>
                                    </td>
                                </tr>

                            </tbody>
                        </table>
                    </div>

                </div>
                <div
                    class="col-span-3 bg-white dark:bg-gray-800 p-6 rounded-xl border border-gray-50 flex flex-col space-y-6 dark:border-none">
                    <div class="flex justify-between items-center">
                        <h2 class="text-sm text-gray-600 dark:text-gray-400 font-bold tracking-wide">Tous les clients
                        </h2>
                    </div>

                    <div class="relative overflow-x-auto shadow-md sm:rounded-lg">
                        <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
                            <thead
                                class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
                                <tr>
                                    <th scope="col" class="px-6 py-3">
                                        Nom
                                    </th>
                                    <th scope="col" class="px-6 py-3">
                                        Email
                                    </th>

                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="cli in allClient"
                                    class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600">
                                    <th scope="row"
                                        class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                        {{ cli.name }}
                                    </th>
                                    <td class="px-6 py-4">
                                        {{ cli.email }}
                                    </td>

                                </tr>

                            </tbody>
                        </table>
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
import { decl } from 'postcss';
import { Bar } from 'vue-chartjs'

ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend)

export default {
    name: 'App',
    components: {
        Bar
    },
    data() {
        return {
            data: {
                labels: ['January', 'February', 'March'],
                datasets: [{
                    data: [40, 20, 12],
                    backgroundColor: ['rgba(54, 162, 235, 0.6)', 'rgba(75, 192, 192, 0.6)', 'rgba(255, 99, 132, 0.6)'],
                    borderColor: ['rgba(54, 162, 235, 1)', 'rgba(75, 192, 192, 1)', 'rgba(255, 99, 132, 1)'],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true
            }
        }
    }
}
</script>