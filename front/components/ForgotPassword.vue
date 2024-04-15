<script>

</script>

<template>
  <html>

  <head>
    <meta charset="utf-8">
    <title> </title>
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
                <span class="padding-bottom--15"> Recuperation Compte </span>
                <div class="field padding-bottom--24">
                  <label for="email">Email</label>
                  <input type="email" name="email" placeholder="Saisissez votre email" v-model="email">
                </div>
                <div class="field padding-bottom--24">
                  <div class="grid--50-50">
                    <!-- <label for="password">Mot de passe</label> -->
                    <div class="reset-pass">
                      <!-- <a href="#">mot de passe oublie? </a> -->
                    </div>
                  </div>
                </div>
                <div class="field padding-bottom--24">
                  <button @click="recupere()" type="button"
                    class="inline-block rounded bg-neutral-800 px-6 pb-2 pt-2.5 text-xs font-medium uppercase leading-normal text-neutral-50 shadow-[0_4px_9px_-4px_rgba(51,45,45,0.7)] transition duration-150 ease-in-out hover:bg-neutral-800 hover:shadow-[0_8px_9px_-4px_rgba(51,45,45,0.2),0_4px_18px_0_rgba(51,45,45,0.1)] focus:bg-neutral-800 focus:shadow-[0_8px_9px_-4px_rgba(51,45,45,0.2),0_4px_18px_0_rgba(51,45,45,0.1)] focus:outline-none focus:ring-0 active:bg-neutral-900 active:shadow-[0_8px_9px_-4px_rgba(51,45,45,0.2),0_4px_18px_0_rgba(51,45,45,0.1)] dark:bg-neutral-900 dark:shadow-[0_4px_9px_-4px_#030202] dark:hover:bg-neutral-900 dark:hover:shadow-[0_8px_9px_-4px_rgba(3,2,2,0.3),0_4px_18px_0_rgba(3,2,2,0.2)] dark:focus:bg-neutral-900 dark:focus:shadow-[0_8px_9px_-4px_rgba(3,2,2,0.3),0_4px_18px_0_rgba(3,2,2,0.2)] dark:active:bg-neutral-900 dark:active:shadow-[0_8px_9px_-4px_rgba(3,2,2,0.3),0_4px_18px_0_rgba(3,2,2,0.2)]">
                    R E C U P E R E R
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
      'email': '',
    }
  },
  methods: {
    recupere() {
      let emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/
      if (this.email == '' ) {
        Swal.fire({
          icon: 'warning',
          title: '...',
          text: 'Veuillez remplir tous les champs s\'il vous plait',
        })
      }
      else if(!emailPattern.test(this.email)){
        Swal.fire(
          'Veuillez  saisir un adresse email s\'il vous plait',
          '',
          'warning'
        )
      }
      else {
        //Swal loading
        Swal.fire({
        title: 'En cours de traitement...',
        allowOutsideClick: false,
        allowEscapeKey: false,
        allowEnterKey: false,
        didOpen: () => {
            Swal.showLoading()
        }
    });
        
         $fetch('http://localhost:8000/api/forgot-password', {
                  method: 'POST',
                  body: {
                      'email': this.email,
                  }
              }).then((res) => {
                //Swal close
                Swal.close()
                if(res.data.value.code == "success"){
                  Swal.fire({
                    icon: 'success',
                    title: '...',
                    text: 'Un lien de réinitialisation vous a été envoyé par mail',
                    timer: 3000,
                    showConfirmButton: false
                  })
                }
                else {
                  Swal.fire({
                    icon: 'error',
                    title: '...',
                    text: 'Cet email n\'existe pas',
                  })
                }
              })
        }
      }
      }
  }
</script>
