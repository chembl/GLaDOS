import Vue from 'vue'
import Vuex from 'vuex'
import Api from '@/services/Api.js'

Vue.use(Vuex)

export const store = new Vuex.Store({
  state: {
    loading: true,
    similarCompounds: []
  },
  mutations: {
    SET_LOADING (state, flag) {
      state.loading = flag
    },
    SET_SIMILAR_COMPOUNDS (state, similarCompounds) {
      similarCompounds.map((similarCompounds, i) => {
        similarCompounds.show = false
        return similarCompounds
      })
      state.similarCompounds = similarCompounds
    }
  },
  actions: {
    loadCountries: function ({ commit }, payload) {
      let body = payload.body
      console.log(body)
      commit('SET_LOADING', true)
      Api()
        .post('/test', body)
        .then(similarCompounds => {
          commit('SET_SIMILAR_COMPOUNDS', similarCompounds.data)
          commit('SET_LOADING', false)
        })
    }
  },
  getters: {
    similarCompounds: state => state.similarCompounds
  }
})
