<script>

</script>

<template>
  <html>

  <head>
    <meta charset="utf-8">
    <title> Nouveau Mon de passe </title>
    <link rel="stylesheet" href="style.css">
  </head>

  <body>
    <div class="login-root">
      <div class="box-root flex-flex flex-direction--column" style="min-height: 100vh;flex-grow: 1;">
        <div class="loginbackground box-background--white padding-top--64">
          <div class="loginbackground-gridContainer">
            <div class="box-root flex-flex" style="grid-area: top / start / 8 / end;">
              <div class="box-root"
                style="background-image: linear-gradient(white 0%, rgb(247, 250, 252) 33%); flex-grow: 1;">
              </div>
            </div>
            <div class="box-root flex-flex" style="grid-area: 4 / 2 / auto / 5;">
              <div class="box-root box-divider--light-all-2 animationLeftRight tans3s" style="flex-grow: 1;"></div>
            </div>
            <div class="box-root flex-flex" style="grid-area: 6 / start / auto / 2;">
              <div class="box-root box-background--blue800" style="flex-grow: 1;"></div>
            </div>
            <div class="box-root flex-flex" style="grid-area: 7 / start / auto / 4;">
              <div class="box-root box-background--blue animationLeftRight" style="flex-grow: 1;"></div>
            </div>
            <div class="box-root flex-flex" style="grid-area: 8 / 4 / auto / 6;">
              <div class="box-root box-background--gray100 animationLeftRight tans3s" style="flex-grow: 1;"></div>
            </div>
            <div class="box-root flex-flex" style="grid-area: 2 / 15 / auto / end;">
              <div class="box-root box-background--cyan200 animationRightLeft tans4s" style="flex-grow: 1;"></div>
            </div>
            <div class="box-root flex-flex" style="grid-area: 3 / 14 / auto / end;">
              <div class="box-root box-background--blue animationRightLeft" style="flex-grow: 1;"></div>
            </div>
            <div class="box-root flex-flex" style="grid-area: 4 / 17 / auto / 20;">
              <div class="box-root box-background--gray100 animationRightLeft tans4s" style="flex-grow: 1;"></div>
            </div>
            <div class="box-root flex-flex" style="grid-area: 5 / 14 / auto / 17;">
              <div class="box-root box-divider--light-all-2 animationRightLeft tans3s" style="flex-grow: 1;"></div>
            </div>
          </div>
        </div>
        <div class="box-root padding-top--24 flex-flex flex-direction--column" style="flex-grow: 1; z-index: 9;">
          <div class="box-root padding-top--48 padding-bottom--24 flex-flex flex-justifyContent--center">
            <h1><a href="http://blog.stackfindover.com/" rel="dofollow">EventPass</a></h1>
          </div>
          <div class="formbg-outer">
            <div class="formbg">
              <div class="formbg-inner padding-horizontal--48">
                <span class="padding-bottom--15">Mise a jour du mot de passe</span>
                <div class="field padding-bottom--24">
                  <label for="email">Nouveau mot de passe</label>
                  <input type="text" name="password" placeholder="Saisissez votre nouveau mot de passe"
                    v-model="password">
                </div>
                <div class="field padding-bottom--24">
                  <div class="grid--50-50">
                    <label for="password">Confirmer votre mot de passe</label>
                  </div>
                  <div class="relative flex items-stretch">
                    <input :type="passwordType" name="password" v-model="copassword"
                      class="border rounded-l-md py-2 px-3 w-full" placeholder="Saisissez votre mot de passe">
                    <button @click="togglePassword()" type="button"
                      class="border-l border-white-700  focus:ring-4 focus:outline-none focus:ring-white-300 font-medium text-sm p-2.5 text-center inline-flex items-center absolute right-0 top-0 bottom-0 dark:border-white-500 dark:text-white-500 dark:hover:text-white dark:focus:ring-white-800 ">
                      <svg v-if="passwordType === 'password'" xmlns="http://www.w3.org/2000/svg" fill="none"
                        viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                        <path stroke-linecap="round" stroke-linejoin="round"
                          d="M2.036 12.322a1.012 1.012 0 010-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178z" />
                        <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                      </svg>

                      <svg v-else xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                        stroke="currentColor" class="w-6 h-6">
                        <path stroke-linecap="round" stroke-linejoin="round"
                          d="M3.98 8.223A10.477 10.477 0 001.934 12C3.226 16.338 7.244 19.5 12 19.5c.993 0 1.953-.138 2.863-.395M6.228 6.228A10.45 10.45 0 0112 4.5c4.756 0 8.773 3.162 10.065 7.498a10.523 10.523 0 01-4.293 5.774M6.228 6.228L3 3m3.228 3.228l3.65 3.65m7.894 7.894L21 21m-3.228-3.228l-3.65-3.65m0 0a3 3 0 10-4.243-4.243m4.242 4.242L9.88 9.88" />
                      </svg>

                      <span class="sr-only">Toggle Password Visibility</span>
                    </button>
                  </div>



                </div>
                <div class="field padding-bottom--24">
                  <button @click="mirajane()" type="button"
                    class="inline-block rounded bg-neutral-800 px-6 pb-2 pt-2.5 text-xs font-medium uppercase leading-normal text-neutral-50 shadow-[0_4px_9px_-4px_rgba(51,45,45,0.7)] transition duration-150 ease-in-out hover:bg-neutral-800 hover:shadow-[0_8px_9px_-4px_rgba(51,45,45,0.2),0_4px_18px_0_rgba(51,45,45,0.1)] focus:bg-neutral-800 focus:shadow-[0_8px_9px_-4px_rgba(51,45,45,0.2),0_4px_18px_0_rgba(51,45,45,0.1)] focus:outline-none focus:ring-0 active:bg-neutral-900 active:shadow-[0_8px_9px_-4px_rgba(51,45,45,0.2),0_4px_18px_0_rgba(51,45,45,0.1)] dark:bg-neutral-900 dark:shadow-[0_4px_9px_-4px_#030202] dark:hover:bg-neutral-900 dark:hover:shadow-[0_8px_9px_-4px_rgba(3,2,2,0.3),0_4px_18px_0_rgba(3,2,2,0.2)] dark:focus:bg-neutral-900 dark:focus:shadow-[0_8px_9px_-4px_rgba(3,2,2,0.3),0_4px_18px_0_rgba(3,2,2,0.2)] dark:active:bg-neutral-900 dark:active:shadow-[0_8px_9px_-4px_rgba(3,2,2,0.3),0_4px_18px_0_rgba(3,2,2,0.2)]">
                    Mettre à jour
                  </button>
                </div>
              </div>
            </div>
            <div class="footer-link padding-top--24">
              <span>Pas encore de compte ? <NuxtLink to="/creation">Registration</NuxtLink></span>
              <!-- <div class="listing padding-top--24 padding-bottom--24 flex-flex center-center">
                <span><a href="#">Contact</a></span>
                <span><a href="#">Privacy & terms</a></span>
              </div> -->
            </div>
          </div>
        </div>
      </div>
    </div>
  </body>

  </html>
</template>

<script>
import Swal from 'sweetalert2'

export default {
  name: 'Login',
  data() {
    return {
      copassword: '',
      password: '', 
      passwordType: 'password'
    }
  },
  methods: {
    togglePassword() {
      this.passwordType = this.passwordType === 'password' ? 'text' : 'password';
    },
    mirajane() {
      //recuperer le token dasn le route localhost:8000/api/reset-password/?code=token
      const token = this.$route.query.code;
      //verifier si les champs sont vide
      if (this.password == '' || this.copassword == '') {
        Swal.fire({
          icon: 'error',
          title: '...',
          text: 'Veuillez remplir tous les champs',
        })
      } else if (this.password != this.copassword) {
          Swal.fire({
            icon: 'error',
            title: '...',
            text: 'Les deux mot de passe ne sont pas identique',
          })
        }
      else {
        const { data } = useFetch('http://localhost:8000/api/reset-password', {
                  method: 'POST',
                  body: {
                      'token': token,
                      'password': this.password
                  }
              }).then((res) => {
                console.log(res);
                if(res.data.value.code == "success"){
                  //met un timer comme 3 secondes avant de rediriger vers la page de connexion
                  Swal.fire({
                    icon: 'success',
                    title: '...',
                    text: 'Votre mot de passe a été mis à jour avec succès' ,
                  })
                  setTimeout(() => 
                  {
                    return navigateTo('/login')
                  }, 3000);
                  
                }
                else{
                  Swal.fire({
                    icon: 'error',
                    title: '...',
                    text: 'Une erreur est survenue' ,
                  })
                }
              })
        }
      }
      }
  }
</script>
