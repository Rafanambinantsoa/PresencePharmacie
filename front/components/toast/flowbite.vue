<script setup>

const items = ref([
    {message : 'This is a default toast message'},
    {message : 'This is a success toast message'},
    {message : 'This is a danger toast message'},
    {message : 'This is a warning toast message'},
])

function remove(index){
    items.value.splice(index,1)
}

</script>
<template>
    <div class="fixed top-4 right-14 z-50  space-y-4  w-full max-w-xs">
        <ToastList
        v-for="(item , indec) in items"
        :key="index"
        :message="item.message"
        @remove="remove(index)" />
    </div>
</template>