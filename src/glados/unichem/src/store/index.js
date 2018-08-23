import Vue from 'vue'
import Vuex from 'vuex'
import Api from '@/services/Api.js'

Vue.use(Vuex)

export const store = new Vuex.Store({
  state: {
    loading: true,
    proteins: [],
    proteinsCount: 0
  },
  mutations: {
    SET_LOADING (state, flag) {
      state.loading = flag
    },
    SET_PROTEINS (state, proteins) {
      proteins.map((protein, i) => {
        protein.show = false
        return protein
      })
      state.proteins = proteins
    },
    SET_PROTEINS_COUNT (state, count) {
      state.proteinsCount = count
    }
  },
  actions: {
    loadProteins: function ({ commit }, payload) {
      let params = payload.params
      commit('SET_LOADING', true)
      Api()
        .get('/proteins', { params })
        .then(r => {
          commit('SET_PROTEINS_COUNT', r.headers['x-pagination-totalrecords'])
          return r.data
        })
        .then(proteins => {
          commit('SET_PROTEINS', proteins)
          commit('SET_LOADING', false)
        })
    }
  },
  getters: {
    proteins: state => state.proteins,
    proteinsCount: state => state.proteinsCount
  }
})
