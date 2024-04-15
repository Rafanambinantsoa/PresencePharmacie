export default defineNuxtRouteMiddleware((to, from) => {
    const token = useCookie('token');
    const role = useCookie('idao');
    if (!token.value) {
        return navigateTo('/login');
    }
    if(role.value == "0"){
        return navigateTo('/');
    }
    if(role.value == "admin"){
        return navigateTo('/admin');
    }
})