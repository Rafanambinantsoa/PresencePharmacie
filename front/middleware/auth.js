export default defineNuxtRouteMiddleware((to, from) => {
  const token = useCookie('token');
  const role = useCookie('idao');
  if (!token.value) {
    return navigateTo('/login');
  }
  if (role.value == "admin") {
    return navigateTo('/admin');
  }
  if(role.value == "organisateur"){
    return navigateTo('/organ');
  }
})