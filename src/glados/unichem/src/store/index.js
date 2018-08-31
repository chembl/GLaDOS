import Vue from 'vue'
import Vuex from 'vuex'
import Api from '@/services/Api.js'

Vue.use(Vuex)

export const store = new Vuex.Store({
  state: {
    loading: true,
    countries: []
  },
  mutations: {
    SET_LOADING (state, flag) {
      state.loading = flag
    },
    SET_COUNTRIES (state, countries) {
      state.countries = countries
    }
  },
  actions: {
    loadCountries: function ({ commit }, payload) {
      let params = payload.params
      commit('SET_LOADING', true)
      Api()
        .get('/test', { params })
        .then(countries => {
          commit('SET_COUNTRIES', countries)
          commit('SET_LOADING', false)
        })
    }
  },
  getters: {
    countries: state => state.countries
  }
})
