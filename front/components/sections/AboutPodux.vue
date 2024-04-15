<script setup>
const token = useCookie("token")
import { uri } from '~/stores/uri';


const { data: tousLesEvents } = await useAsyncData(() =>
    $fetch(`${uri}nombreTousEvent`, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    })
);

const { data: lesEventsEnCours } = await useAsyncData(() =>
    $fetch(`${uri}nombreEventEnCours`, {
        headers: {
            'Authorization': 'Bearer ' + token.value
        }
    })
);

// const { data: encours } = await useAsyncData("products", () =>
//     $fetch("http://localhost:8000/api/eventEncoursCount")
// );

console.log(lesEventsEnCours.value);
console.log(tousLesEvents.value);
</script>

<template>
    <section id="about" class="pt-20 md:pt-24">
        <AtomsContainer>
            <div class="grid md:grid-cols-2 gap-10 xl:gap-14 relative">
                <div class="flex md:h-full ">
                    <div
                        class="w-full md:h-full rounded-3xl bg-white dark:bg-body shadow-lg shadow-box-shadow border border-box-border">
                        <img src="/images/concentrated-young-african-american.webp" alt="Illustratuin about" width="500"
                            class="w-full h-full object-cover rounded-2xl">
                    </div>
                </div>
                <div class="md:py-2 lg:py-4 relative">
                    <div class="absolute right-0 top-0 h-full w-full flex justify-end">
                        <span class="flex opacity-20">
                            <span class="w-16 h-32 rounded-l-full flex bg-primary blur-2xl"></span>
                            <span class="w-16 h-32 rounded-r-full flex bg-[#f88fc2] blur-2xl mt-14"></span>
                        </span>
                    </div>
                    <div class="relative">
                        <AtomsTitle texte="Découvrez la prochaine génération de plateformes de vente de billets." />
                        <p class="text-gray-600 dark:text-gray-300 pt-8">
                            "Notre plateforme se distingue comme le meilleur choix, offrant une navigation fluide, une
                            vaste
                            sélection d'événements et des transactions sécurisées. Ne vous contentez pas de moins ;
                            améliorez votre expérience événementielle avec nous. Découvrez, réservez et profitez des
                            meilleurs événements en toute simplicité. Votre satisfaction est notre priorité !"
                        </p>
                        <div class="grid grid-cols-3 gap-4 max-w-lg pt-8">
                            <div
                                class="text-center rounded-xl bg-box-bg shadow-lg shadow-box-shadow border border-box-border p-3">
                                <h3 class="text-gray-800 dark:text-white font-bold text-xl sm:text-2xl lg:text-3xl">
                                    {{ lesEventsEnCours }}
                                </h3>
                                <p class="text-sm sm:text-base text-gray-600 dark:text-gray-300">Événement en Cours</p>
                            </div>
                            <div
                                class="text-center rounded-xl bg-box-bg shadow-lg shadow-box-shadow border border-box-border p-3">
                                <!-- <h3 class="text-gray-800 dark:text-white font-bold text-xl sm:text-2xl lg:text-3xl">+
                                    500</h3>
                                <p class="text-sm sm:text-base text-gray-600 dark:text-gray-300">Nombre des even en cours</p> -->
                            </div>
                            <div
                                class="text-center rounded-xl bg-box-bg shadow-lg shadow-box-shadow border border-box-border p-3">
                                <h3 class="text-gray-800 dark:text-white font-bold text-xl sm:text-2xl lg:text-3xl">
                                    {{ tousLesEvents }}
                                </h3>
                                <p class="text-sm sm:text-base text-gray-600 dark:text-gray-300">Tous les Événements
                                </p>
                            </div>
                        </div>
                        <!-- <div class="pt-10 flex">
                            <AtomsLinkBtn href="#" variant="primary">
                                Know more
                            </AtomsLinkBtn>
                        </div> -->
                    </div>
                </div>
            </div>
        </AtomsContainer>
    </section>
</template>