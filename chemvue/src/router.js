import Vue from "vue";
import Router from "vue-router";
import Similarity from "@/views/unichem/Similarity";
import HelloWorld from "@/views/HelloWorld";
Vue.use(Router);

export default new Router({
  // mode: "history",
  base: process.env.BASE_URL,
  routes: [
    {
      path: "/",
      name: "Similarity",
      component: Similarity
    },
    {
      path: "/test",
      name: "HelloWorld",
      component: HelloWorld
      // route level code-splitting
      // this generates a separate chunk (about.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      // component: () =>
      //   import(/* webpackChunkName: "about" */ "./components/HelloWorld.vue")
    },
    {
      path: "/chembl_game",
      name: "ChEMBLGame",
      component: () => import("@/views/chembl/ChEMBLGame.vue")
    }
  ]
});
