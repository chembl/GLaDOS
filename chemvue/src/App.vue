<template>
  <v-app>
    <v-navigation-drawer
      persistent
      width="200"
      :mini-variant="miniVariant"
      :clipped="clipped"
      v-model="drawer"
      enable-resize-watcher
      fixed
      absolute
      app
    >
      <v-list>
        <v-list-tile v-for="(item, i) in items" :key="i" :to="item.path">
          <v-list-tile-action>
            <v-icon v-html="item.icon"></v-icon>
          </v-list-tile-action>
          <v-list-tile-content>
            <v-list-tile-title v-text="item.title"></v-list-tile-title>
          </v-list-tile-content>
        </v-list-tile>
      </v-list>
    </v-navigation-drawer>
    <v-toolbar
      app
      :clipped-left="clipped"
      dark
      color="primary"
      height="70"
      absolute
    >
      <v-toolbar-side-icon @click.stop="drawer = !drawer"></v-toolbar-side-icon>
      <v-btn icon @click.stop="miniVariant = !miniVariant">
        <v-icon
          v-html="miniVariant ? 'chevron_right' : 'chevron_left'"
        ></v-icon>
      </v-btn>
      <div class="brand-icon ma-2 pt-1">
        <img src="@/assets/unichem_logo.png" alt />
      </div>
      <v-toolbar-title v-text="title"></v-toolbar-title>
      <v-spacer></v-spacer>
      <div class="brand-icon ma-2 pt-1">
        <a href="/">
          <img src="@/assets/chembl_logo_pink.png" alt />
        </a>
      </div>
    </v-toolbar>
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
  </v-app>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">
nav {
  height: initial;
  line-height: initial;

  i {
    height: initial;
    line-height: initial;
  }
}

h1,
h2 {
  font-weight: normal;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: inline-block;
  margin: 0 10px;
}

a {
  color: #42b983;
}

.brand-icon {
  img {
    width: 3em;
  }
}
</style>

<script>
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
  temp_proteins: [],
  name: "App"
};
</script>
