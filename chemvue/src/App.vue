<template>
  <v-app>
    <EBIHeader></EBIHeader>
    <div
      id="masthead"
      class="masthead"
      data-sticky
      data-sticky-on="large"
      data-top-anchor="main-content-area:top"
      data-btm-anchor="main-content-area:bottom"
    ></div>
    <Header></Header>
    <!-- Splash screen -->
    <div
      v-if="splashScreen"
      id="GladosMainSplashScreen"
      class="loader-background"
    >
      <div class="card splash-card z-depth-0">
        <div class="loader-container">
          <div class="spinner">
            <div class="ball ball-1"></div>
            <div class="ball ball-2"></div>
            <div class="ball ball-3"></div>
            <div class="ball ball-4"></div>
            <div class="ball ball-5"></div>
            <div class="ball ball-6"></div>
          </div>
          <span class="chembl-logo center-align">ChEMBL</span>
          <span class="center-align loading-msg">Loading...</span>
        </div>
      </div>
    </div>
    <v-content>
      <router-view />
    </v-content>
    <EBIFooter></EBIFooter>
  </v-app>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">
// @import "./assets/ebi-feeling/css/ebi-lite.min.css";
</style>

<script>
import EBIHeader from "./components/EBIcomponents/Header";
import EBIFooter from "./components/EBIcomponents/Footer";
import Header from "./components/shared/Header";

export default {
  data() {
    return {
      topval: "10px",
      splashScreen: false,
      clipped: false,
      drawer: true,
      fixed: false,
      items: [
        {
          icon: "home",
          title: "Home",
          path: "/"
        },
        {
          icon: "low_priority",
          title: "Test",
          path: "/test"
        }
      ],
      miniVariant: true,
      right: false,
      rightDrawer: false,
      title: "UNICHEM"
    };
  },
  name: "App",
  components: {
    EBIHeader,
    EBIFooter,
    Header
  }
};
</script>
