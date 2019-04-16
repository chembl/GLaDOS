import "@mdi/font/css/materialdesignicons.css";
import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import store from "./store";
import Vuetify from "vuetify";
import axios from "axios";
import VueAxios from "vue-axios";
import LoadScript from "vue-plugin-load-script";
import "./assets/stylus/main.styl";

Vue.use(LoadScript);

Vue.use(VueAxios, axios);

Vue.use(Vuetify, {
  theme: {
    primary: "#07979b",
    secondary: "#4d5456",
    accent: "#0e595f",
    error: "#FF5252",
    info: "#2196F3",
    success: "#4CAF50",
    warning: "#FFC107"
  },
  iconfont: `mdi`
});

Vue.config.productionTip = false;

new Vue({
  router,
  store,
  render: h => h(App),
  components: {}
}).$mount("#app");
