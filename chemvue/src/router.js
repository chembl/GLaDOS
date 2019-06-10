import Vue from 'vue';
import Router from 'vue-router';
import Similarity from '@/views/unichem/Similarity';
import Sources from '@/views/unichem/Sources';
import HelloWorld from '@/views/HelloWorld';
import PageNotFound from '@/views/PageNotFound';
import ChEMBLPlayground from '@/views/chembl/ChEMBLPlayground.vue';

Vue.use(Router);

export default new Router({
  // mode: "history",
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/',
      name: 'Similarity',
      component: Similarity
    },
    {
      path: '/sources',
      name: 'Sources',
      component: Sources
    },
    {
      path: '/test',
      name: 'HelloWorld',
      component: HelloWorld
      // route level code-splitting
      // this generates a separate chunk (about.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      // component: () =>
      //   import(/* webpackChunkName: "about" */ "./components/HelloWorld.vue")
    },
    {
      path: '/404',
      name: 'PageNotFound',
      component: PageNotFound
    },
    {
      path: '*',
      redirect: '/404'
    },
    {
      path: '/chembl_playground',
      name: 'ChEMBLGame',
      component: ChEMBLPlayground
    }
  ]
});
