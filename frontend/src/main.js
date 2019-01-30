// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import Vuetify from 'vuetify'
import './assets/stylus/main.styl'
import '@mdi/font/css/materialdesignicons.css'
import { store } from './store'
import axios from 'axios'
import VueAxios from 'vue-axios'

Vue.use(VueAxios, axios)

Vue.use(Vuetify, { theme: {
  primary: '#07979b',
  secondary: '#4d5456',
  accent: '#0e595f',
  error: '#FF5252',
  info: '#2196F3',
  success: '#4CAF50',
  warning: '#FFC107'
}})

Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  el: '#unichem-app',
  router,
  store,
  components: { App },
  template: '<App/>'
})
