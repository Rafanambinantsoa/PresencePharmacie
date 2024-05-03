<template>
    <div class="w-1/2 p-4">
        <button :class="['group relative h-10 w-60 overflow-hidden rounded-lg bg-white text-base shadow text-center p-2 cursor-pointer', { 'opacity-50': isDisabled }]"
            :disabled="isDisabled">
        <div class="absolute inset-0 w-2 bg-gray-400 transition-all duration-250 ease-out group-hover:w-full">
        </div>
        <span class="px-1 relative text-black group-hover:text-white">
            {{ isLoading ? 'Chargement...' : text  }}
        </span>
        <svg v-if="isLoading" class="animate-spin h-5 w-5 absolute right-2 top-2 text-gray-600"
            xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V2.5"></path>
        </svg>
        </button>
    </div>
</template>

<script>
export default {
    props: {
        isDisabled: Boolean,
        isLoading: Boolean,
        text: String,
    },
}
</script>