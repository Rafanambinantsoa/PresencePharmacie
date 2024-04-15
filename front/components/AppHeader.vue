<script lang="ts" setup>
import { uri } from '~/stores/uri';
const navIsOpen = useState('navIsOpen', () => false)


const state = reactive({
    propsButton: false,
    vanilaToken: ""
})

function toggleNav(event: MouseEvent): void {
    event.preventDefault()
    navIsOpen.value = !navIsOpen.value
}

const navLinks = [
    {
        text: "Récents",
        href: "#latestEvent"
    },
    {
        text: "Événements",
        href: "#allEvents"
    },
    {
        text: "Pourquoi ?",
        href: "#why"
    },
    {
        text: "Nous contactez",
        href: "#contact"
    },
    {
        text: "À Propos",
        href: "#about"
    },
]

import { useCartStore } from '~/stores/cart';
import { toast } from 'vue3-toastify';
import 'vue3-toastify/dist/index.css';

const cartStore = useCartStore();

const openModale = () => {
    my_modal_1.showModal()
    console.log(cartStore.cartItems);

}

const increaseMe = (id) => {
    cartStore.increaseQuantity(id)
}

const decreaseMe = (id) => {
    cartStore.decreaseQuantity(id)
}

const removeMe = (idao) => {
    cartStore.removeFromCart(idao)
}
//Deconnexion
const deconnexion = () => {
    document.cookie = "token=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;"
    document.cookie = "idao=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;"
}


//Affichage du nom de celui qui est connecte

const token = useCookie("token");

//Nom admin
const { data: users } = await useAsyncData("Users", () =>
    $fetch(`${uri}user`, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    })
);

import Swal from 'sweetalert2'

const panierMe = () => {
    Swal.fire({
        title: 'Chargement en cours...',
        allowOutsideClick: false,
        allowEscapeKey: false,
        allowEnterKey: false,
        didOpen: () => {
            Swal.showLoading()
        }
    });
    $fetch(`${uri}commande`, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        },
        method: 'POST',
        body: {
            data: cartStore.cartItems,
            total: cartStore.totalPrice,
            user_id: users.value.id,
            email: users.value.email
        }
    }).then((res) => {
        console.log(res);
        Swal.close()
        navigateTo(res, {
            external: true
        })
        // Swal.fire({
        //     icon: res.status,
        //     title: res.message,
        //     showConfirmButton: false,
        //     timer: 1500
        // })
    })
}

//Historique 
const detailHistorique = ref(null);
const sommeTotal = ref(null);


// Affichage de details de mon historique  en cours 
const mesHistoriques = async () => {
    try {
        // Utilisez la méthode $fetch de Nuxt.js pour récupérer les données depuis l'API
        const response = await $fetch(`${uri}historique/${users.value.id}`, {
            headers: {
                'Authorization': 'Bearer ' + token.value
            }
        });

        // Vérifiez si la réponse a réussi et stockez les données dans la référence 'donee'
        if (response) {
            detailHistorique.value = response;

            const totalMontant = response.reduce((total, commande) => total + commande.montantTotal, 0);
            sommeTotal.value = totalMontant;

            winchester.showModal();
            // Affichez les données dans la console pour vérifier si tout fonctionne correctement
            // console.log(detailEvent.value);
            // Affichez le modal avec les données récupérées
        }
    } catch (error) {
        console.error("Une erreur s'est produite lors de la récupération des données :", error);
    }
}

const myProfile = () => {
    profile.showModal()
}


let model = {
    email: users.value && users.value.email ? users.value.email : "",
    firstname: users.value && users.value.firstname ? users.value.firstname : "",
    lastname: users.value && users.value.lastname ? users.value.lastname : "",
    phone: users.value && users.value.phone ? users.value.phone : "",
    pass: "",
    copass: "",
    passActu: ""
};


const mettreAjour = () => {
    // Vérification si tous les champs obligatoires sont remplis
    if (model.email === "" || model.firstname === "" || model.lastname === "" || model.phone === "" || model.passActu === "") {
        toast.warning("Veuillez remplir tous les champs obligatoires", {
            autoClose: 4000
        });
        return;
    }

    // Si l'utilisateur ne souhaite pas changer de mot de passe
    if (model.copass === "" && model.pass === "") {
        updateUserData(model.passActu, model.passActu);
        return;
    }

    // Si les mots de passe ne correspondent pas
    if (model.pass !== model.copass) {
        toast.warning("Les mots de passe ne correspondent pas", {
            autoClose: 3000
        });
        return;
    }

    // Si tous les champs sont remplis, et que les mots de passe correspondent
    updateUserData(model.passActu, model.copass);
};

// Fonction pour mettre à jour les données utilisateur
const updateUserData = () => {

    const idso = useFetch(`${uri}user/update/${users.value.id}`, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        },
        method: 'POST',
        body: {
            email: model.email,
            firstname: model.firstname,
            lastname: model.lastname,
            phone: model.phone,
            password: model.passActu,
            newpassword: model.pass
        }
    }).then((res) => {
        if (res.data.value.code === 200) {
            toast.success(res.data.value.message, {
                autoClose: 3000
            });
        } else {
            toast.error(res.data.value.message, {
                autoClose: 3000
            });
        }
        refreshNuxtData('Users');
    });
};


const publi = process.env.PUBLIC_KEY
const privat = process.env.PRIVATE_KEY
const key = useCookie("vanila")
async function paiment() {
    state.propsButton = true,
        useFetch("https://api.ipify.org").then((res) => {
            if (res.data.value != null) {
                let ip = res.data.value
                const form = new FormData();

                form.append('site_url', "https://karimrafanambinantsoa.vercel.app/");
                form.append('public_key', "b7751af3f9a3dc37134c81066294e5398d535afd461b66a692");
                form.append('private_key', "093e8ebf96b368c5af8fdf22cc1aad3c327416eaad65ec0c0f");
                form.append("ip", ip.toString());
                form.append("total", "200");
                form.append("idpanier", "akutagawakarim@gmail.com")
                form.append("reference", "dsds")
                form.append("nom", "kim")
                useFetch("https://vanilla.unityfianar.com?format=json", {
                    method: "POST",
                    headers: {
                        "authorization": "Bearer " + key.value
                    }
                    , body: form
                }).then((res) => {
                    state.propsButton = false
                    console.log(res.data.value);
                    let mal = JSON.parse(res.data.value)
                    let idTransaction = mal.id;
                    if (idTransaction != null) {
                        navigateTo(`https://moncompte.ariarynet.com/payer/${idTransaction}`, {
                            external: true
                        })
                    }
                    else {
                        toast.error("Une erreur s'est produite lors de la connexion au serveur", {
                            autoClose: 3000
                        })

                    }
                })
            }
        })
}

</script>
<template>
    <!-- cart -->
    <dialog id="my_modal_1" class="modal">
        <form method="dialog" class="modal-box w-11/12 max-w-5xl">
            <button className="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">✕</button>
            <div class="relative overflow-x-auto shadow-md sm:rounded-lg mt-4">
                <div class="flex mb-3">
                    <div class="w-1/2 p-4 ">
                        <p>Mon panier</p>
                    </div>
                    <div class="w-1/2 p-4 text-right">Montant total : {{ cartStore.totalPrice }} ar </div>
                </div>

                <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
                    <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
                        <tr>
                            <th scope="col" class="px-6 py-3">
                                Produits
                            </th>
                            <th scope="col" class="px-6 py-3">
                                Date de l'event
                            </th>
                            <th scope="col" class="px-6 py-3">
                                Lieu
                            </th>
                            <th scope="col" class="px-6 py-3">
                                Prix
                            </th>
                            <th scope="col" class="px-6 py-3">
                                Total
                            </th>
                            <th scope="col" class="px-6 py-3">
                                Disponible
                            </th>
                            <th scope="col" class="px-6 py-3 text-center">
                                Nombre de billets
                            </th>
                            <th scope="col" class="px-6 py-3 text-center">
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-if="cartStore.cartItems.length > 0" v-for="item in cartStore.cartItems" :key="item.id"
                            class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600">
                            <th scope="row"
                                class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                                {{ item.titre.substring(0, 20) }}...
                            </th>
                            <td class="px-6 py-4">
                                {{ item.date }}
                            </td>
                            <td class="px-6 py-4">
                                {{ item.lieu }}
                            </td>
                            <td class="p00x-6 py-4">
                                {{ item.prix }} ar
                            </td>

                            <td class="px-6 py-4">
                                {{ item.prix * item.quantity }} ar
                            </td>
                            <td class="p00x-6 py-4 text-center">
                                {{ item.limitBillets }}
                            </td>
                            <td class="px-6 py-4 text-center">
                                <button type="button" @click="decreaseMe(item.id)"
                                    class="btn btn-sm btn-circle btn-ghost">-</button>
                                <span class="mx-2"> {{ item.quantity }}</span>
                                <button type="button" @click="increaseMe(item.id)"
                                    class="btn btn-sm btn-circle btn-ghost">+</button>

                            </td>
                            <td class="px-6 py-4">
                                <button @click="removeMe(item.id)" class="btn btn-sm btn-circle btn-ghost"
                                    type="button"><svg xmlns="http://www.w3.org/2000/svg" height="1em"
                                        viewBox="0 0 448 512"><!--! Font Awesome Free 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. -->
                                        <path
                                            d="M135.2 17.7L128 32H32C14.3 32 0 46.3 0 64S14.3 96 32 96H416c17.7 0 32-14.3 32-32s-14.3-32-32-32H320l-7.2-14.3C307.4 6.8 296.3 0 284.2 0H163.8c-12.1 0-23.2 6.8-28.6 17.7zM416 128H32L53.2 467c1.6 25.3 22.6 45 47.9 45H346.9c25.3 0 46.3-19.7 47.9-45L416 128z" />
                                    </svg></button>
                            </td>

                        </tr>

                        <tr v-else>
                            <td colspan="7" class="px-6 py-4">
                                <div class="text-center mt-6 mb-4">
                                    <div role="status">
                                        <svg aria-hidden="true"
                                            class="inline w-8 h-8 mr-2 text-gray-200 animate-spin dark:text-gray-600 fill-blue-600"
                                            viewBox="0 0 100 101" fill="none" xmlns="http://www.w3.org/2000/svg">
                                            <path
                                                d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z"
                                                fill="currentColor" />
                                            <path
                                                d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z"
                                                fill="currentFill" />
                                        </svg>
                                        <span class="sr-only">Loading...</span>
                                    </div>
                                    <p class="mt-2"> Votre panier est vide </p>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="modal-action">
                <!-- if there is a button, it will close the modal -->
                <div v-if="cartStore.cartItems.length > 0" class="flex justify-end mt-5">
                    <IconsButtonLoad :load="state.propsButton" :isDisabled="state.propsButton" :data="'Paiment stripe'"
                        @click="panierMe()" />
                    <!-- <IconsButtonLoad :load="state.propsButton" :isDisabled="state.propsButton" :data="'Mobile money'"
                        @click="paiment()" /> -->
                </div>
            </div>
        </form>
    </dialog>


    <!-- modal historique  -->
    <dialog id="winchester" class="modal">
        <form method="dialog" class="modal-box w-11/12 max-w-5xl">
            <button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">✕</button>
            <h3 class="mb-5"> Historique d'achats </h3>
            <div class="overflow-x-auto">
                <table class="table">
                    <!-- head -->
                    <thead>
                        <tr>
                            <th></th>
                            <th>Evénement </th>
                            <th class="text-center">Billets achetés</th>
                            <th>Montant total</th>
                            <th class="text-center">Date de commande</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(commande, index) in detailHistorique" :key="index" class="hover">
                            <th>{{ commande.id }} </th>
                            <td>{{ commande.titreEvent }}</td>
                            <td class="text-center">{{ commande.quantite }}</td>
                            <td>{{ commande.montantTotal }} ar </td>
                            <td class="text-center">{{ commande.dateCommande }}</td>

                        </tr>

                        <tr>
                            <td></td>
                            <td></td>
                            <td>montant total dépensé</td>
                            <td>{{ sommeTotal }} ar</td>
                        </tr>
                    </tbody>
                </table>
            </div>

        </form>
    </dialog>
    <!-- modal historique fin   -->

    <!-- modal profile  -->
    <dialog id="profile" class="modal">
        <form method="dialog" class="modal-box w-11/12 max-w-5xl">
            <button class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">✕</button>
            <h3 class="mb-5">Mettre à jour mon profil </h3>
            <div class="relative z-0 w-full mb-6 group">
                <input type="email" name="floating_email" id="floating_email" v-model="model.email"
                    class="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                    placeholder=" " />
                <label for="floating_email"
                    class="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">Adresse
                    Email <span class="text-red-900 text-bold">*</span>
                </label>
            </div>

            <div class="relative z-0 w-full mb-6 group">
                <input type="text" name="floating_email" id="floating_email" v-model="model.firstname"
                    class="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                    placeholder=" " />
                <label for="floating_email"
                    class="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">Nom
                    <span class="text-red-900 text-bold">*</span> </label>
            </div>
            <div class="relative z-0 w-full mb-6 group">
                <input type="text" name="floating_email" id="floating_email" v-model="model.lastname"
                    class="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                    placeholder=" " />
                <label for="floating_email"
                    class="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">Prenom
                    <span class="text-red-900 text-bold">*</span> </label>
            </div>

            <div class="relative z-0 w-full mb-6 group">
                <input type="text" name="floating_email" id="floating_email" v-model="model.phone"
                    class="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                    placeholder=" " />
                <label for="floating_email"
                    class="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">Telephone
                    <span class="text-red-900 text-bold">*</span> </label>
            </div>

            <div class="relative z-0 w-full mb-6 group">
                <input type="password" name="floating_email" id="floating_email" v-model="model.passActu"
                    class="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                    placeholder=" " />
                <label for="floating_email"
                    class="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">Mot
                    de passe actuel <span class="text-red-900 text-bold">*</span></label>
            </div>

            <div class="relative z-0 w-full mb-6 group">
                <input type="password" name="floating_email" id="floating_email" v-model="model.pass"
                    class="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                    placeholder=" " />
                <label for="floating_email"
                    class="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">Nouveau
                    mot de passe</label>
            </div>

            <div class="relative z-0 w-full mb-6 group">
                <input type="text" name="floating_email" id="floating_email" v-model="model.copass"
                    class="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                    placeholder=" " />
                <label for="floating_email"
                    class="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">Confirmation
                    mot de passe </label>
            </div>

            <button type="button" @click="mettreAjour()"
                class="text-gray-900 bg-white hover:bg-gray-100 border border-gray-200 focus:ring-4 focus:outline-none focus:ring-gray-100 font-medium rounded-lg text-sm px-5 py-2.5 text-center inline-flex items-center dark:focus:ring-gray-600 dark:bg-gray-800 dark:border-gray-700 dark:text-white dark:hover:bg-gray-700 mr-2 mb-2">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                    stroke="currentColor" class="w-8 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round"
                        d="M12 16.5V9.75m0 0l3 3m-3-3l-3 3M6.75 19.5a4.5 4.5 0 01-1.41-8.775 5.25 5.25 0 0110.233-2.33 3 3 0 013.758 3.848A3.752 3.752 0 0118 19.5H6.75z" />
                </svg>
                <span class="ml-2">Mettre à jour</span>
            </button>
            <div class="badge badge-sm ml-5"><span class="text-red-900 text-bold">( * )</span> Ces champs sont
                obligatoires
            </div>
            <div class="badge badge-sm ml-5"><span class="text-red-900 text-bold">( ** )</span> Si vous changer votre
                mot de
                passe vous allez etre deconnecter apres
            </div>



        </form>
    </dialog>
    <!-- modal profile fin   -->


    <header class="absolute inset-x-0 top-0 py-3 z-50">
        <AtomsContainer class-name="relative">

            <nav class="flex items-center justify-between w-full relative">
                <!-- app logo -->
                <div class="inline-flex relative bg-inherit">
                    <NuxtLink to="/" class=" flex items-center gap-2">
                        <span class="flex">
                            <span class="w-3 h-6 rounded-l-full flex bg-primary"></span>
                            <span class="w-3 h-6 rounded-r-full flex bg-[#f88fc2] mt-2"></span>
                        </span>
                        <span class="text-lg text-gray-700 dark:text-white">EventPass</span>
                    </NuxtLink>
                </div>
                <div class="absolute top-full px-5 sm:px-8 md:px-12 lg:px-0 
                    lg:pt-0 lg:top-0 invisible opacity-40 lg:opacity-100 bg-body rounded-xl border border-box-border shadow-lg shadow-box-shadow 
                    lg:border-none lg:shadow-none lg:rounded-none
                    lg:bg-transparent w-full lg:w-max py-6 lg:py-0 lg:visible lg:relative flex 
                    transition-all duration-300 ease-linear origin-top translate-y-6 lg:translate-y-0"
                    :class="navIsOpen ? '!visible !opacity-100 !translate-y-0' : ''">
                    <ul
                        class="text-gray-700 dark:text-gray-100 w-full flex lg:items-center gap-y-4 lg:gap-x-8 flex-col lg:flex-row">
                        <AtomsNavLink v-for="navItem in navLinks" :href="navItem.href" :text="navItem.text" />
                    </ul>
                </div>

                <div class="flex items-center bg-inherit gap-1 lg:gap-3 min-w-max">
                    <ElementsThemeSwitcher />
                    <div class="hidden lg:flex lg:items-center gap-4">
                        <!-- <button type="button" @click="openModale()"
                            class="relative inline-flex items-center p-3 text-sm font-medium text-center bg-transparent rounded-lg hover:bg-green-800 focus:ring-4 focus:outline-none dark:focus:ring-green-300">
                            <ElementsIconsCart />
                            <span class="sr-only">Panier</span>
                            <div
                                class="absolute inline-flex items-center justify-center w-6 h-6 text-xs font-bold text-white bg-red-500 border-2 border-white rounded-full -top-2 -right-2 dark:border-gray-900">
                                {{ cartStore.totalItems }}</div>
                        </button> -->


                        <!-- ... autres éléments ... -->

                        <ElementsDropDown>
                            <template #trigger>
                                <button v-if="users"
                                    class="outline-none bg-transparent p-2.5 rounded-full text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800">
                                    {{ users.firstname.substring(0, 6) }}
                                </button>
                                <button v-else
                                    class="outline-none bg-transparent p-2.5 rounded-full text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800">
                                    John Doe
                                </button>
                            </template>
                            <template #content>
                                <!-- Contenu du menu déroulant -->
                                <ul>
                                    <li>
                                        <button @click="myProfile()">Mon profil</button>
                                    </li>
                                    <li>
                                        <button @click="mesHistoriques()">Historique d'Achat</button>
                                    </li>
                                    <li>
                                        <a href="#" @click="deconnexion()">Déconnexion</a>
                                    </li>
                                </ul>
                            </template>
                        </ElementsDropDown>

                        <!-- ... autres éléments ... -->


                    </div>

                    <div class="flex lg:hidden items-center">
                        <ElementsDropDown>
                            <template #trigger>
                                <button
                                    class="outline-none bg-transparent p-2.5 rounded-full text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                                        stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
                                        <path stroke-linecap="round" stroke-linejoin="round"
                                            d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z" />
                                    </svg>
                                </button>
                            </template>
                            <template #content>
                                <ul class="flex flex-col">
                                    <li
                                        class="flex select-none cursor-pointer items-center gap-3 px-2 py-2 rounded-md transition hover:bg-gray-100 dark:hover:bg-gray-800 text-gray-600 dark:text-gray-200">
                                        <!-- Panier  -->
                                        <button type="button" @click="openModale()"
                                            class="relative inline-flex items-center p-3 text-sm font-medium text-center bg-transparent rounded-lg hover:bg-green-800 focus:ring-4 focus:outline-none dark:focus:ring-green-300">
                                            <svg class="w-3.5 h-3.5 mr-2"
                                                :class="{ 'text-gray-600 dark:text-white': $theme === 'light', 'text-white': $theme === 'dark' }"
                                                aria-hidden="true" xmlns="http://www.w3.org/2000/svg"
                                                fill="currentColor" viewBox="0 0 18 21">
                                                <path
                                                    d="M15 12a1 1 0 0 0 .962-.726l2-7A1 1 0 0 0 17 3H3.77L3.175.745A1 1 0 0 0 2.208 0H1a1 1 0 0 0 0 2h.438l.6 2.255v.019l2 7 .746 2.986A3 3 0 1 0 9 17a2.966 2.966 0 0 0-.184-1h2.368c-.118.32-.18.659-.184 1a3 3 0 1 0 3-3H6.78l-.5-2H15Z" />
                                            </svg>
                                            <span class="sr-only">Panier</span>
                                            <div
                                                class="absolute inline-flex items-center justify-center w-6 h-6 text-xs font-bold text-white bg-red-500 border-2 border-white rounded-full -top-2 -right-2 dark:border-gray-900">
                                                {{ cartStore.totalItems }}</div>
                                        </button>

                                    </li>
                                    <li v-if="hii"
                                        class="flex select-none cursor-pointer items-center gap-3 px-2 py-2 rounded-md transition hover:bg-gray-100 dark:hover:bg-gray-800 text-gray-600 dark:text-gray-200">
                                        {{ hii }}
                                    </li>
                                    <li
                                        class="flex select-none cursor-pointer items-center gap-3 px-2 py-2 rounded-md transition hover:bg-gray-100 dark:hover:bg-gray-800 text-gray-600 dark:text-gray-200">
                                        <button @click="mesHistoriques()">Mes Historiques</button>
                                    </li>

                                    <li
                                        class="flex select-none cursor-pointer items-center gap-3 px-2 py-2 rounded-md transition hover:bg-gray-100 dark:hover:bg-gray-800 text-gray-600 dark:text-gray-200">
                                        <button @click="myProfile()">Mon profil</button>
                                    </li>

                                    <li
                                        class="flex select-none cursor-pointer items-center gap-3 px-2 py-2 rounded-md transition hover:bg-gray-100 dark:hover:bg-gray-800 text-gray-600 dark:text-gray-200">
                                        <a href="#" @click="deconnexion()">Log out</a>
                                    </li>
                                </ul>
                            </template>
                        </ElementsDropDown>
                    </div>
                    <div class="flex lg:hidden border-l border-box-border pl-2">
                        <button @click="toggleNav" class="outline-none w-7 h-auto flex flex-col relative">
                            <span
                                class="w-6 h-0.5 rounded-full bg-gray-500 dark:bg-gray-200 transition-all duration-300 ease-linear"
                                :class="navIsOpen ? 'translate-y-1.5 rotate-[40deg] scale-x-100 ' : ' scale-x-50 origin-left'"></span>
                            <span
                                class="w-6 origin-center  mt-1 h-0.5 rounded-full bg-gray-500 dark:bg-gray-200 transition-all duration-300 ease-linear"
                                :class="navIsOpen ? 'scale-x-0 opacity-0' : ''"></span>
                            <span
                                class="w-6 mt-1 h-0.5 rounded-full bg-gray-500 dark:bg-gray-200 transition-all duration-300 ease-linear"
                                :class="navIsOpen ? '-translate-y-1.5 -rotate-[40deg] scale-x-100 ' : ' scale-x-75 origin-left'"></span>
                        </button>
                    </div>
                </div>
            </nav>
            <!-- <ToastKim message="Yo mon pote" /> -->
        </AtomsContainer>
    </header>
</template>