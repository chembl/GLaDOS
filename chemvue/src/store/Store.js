import Vue from "vue";
import Vuex from "vuex";
import RestAPI from "@/services/Api";
import * as chembl from "@/store/modules/Chembl.js";

Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    chembl
  },
  state: {
    errorFetching: {},
    loading: true,
    similarCompounds: [],
    totalCompounds: 0
  },
  mutations: {
    SET_LOADING(state, flag) {
      state.loading = flag;
    },
    SET_SIMILAR_COMPOUNDS(state, similarCompounds) {
      similarCompounds.inchis.map(similarCompounds => {
        similarCompounds.show = false;
        return similarCompounds;
      });
      state.similarCompounds = similarCompounds.inchis;
      state.totalCompounds = similarCompounds.totalCount;
    },
    SET_FETCHING_SIMILARITY_ERROR(state, error) {
      state.errorFetching = error;
    }
  },
  actions: {
    loadCompounds: function({ commit }, payload) {
      let data = payload.data;
      commit("SET_LOADING", true);
      let params = {
        threshold: payload.threshold,
        init: payload.init,
        end: payload.end
      };
      let config = { params: params };
      //TO DO: Make this a general state variable
      var unichemApi = new RestAPI();
      unichemApi
        .getGLaDOSAPI()
        .post("/similarity/", data, config)
        .then(similarCompounds => {
          if (similarCompounds.data.inchis.length <= 0) {
            commit("SET_FETCHING_SIMILARITY_ERROR", {
              isError: true,
              errorMsg: similarCompounds.data.message
            });
          } else {
            commit("SET_FETCHING_SIMILARITY_ERROR", {
              isError: false,
              errorMsg: ""
            });
            commit("SET_SIMILAR_COMPOUNDS", similarCompounds.data);
          }
          commit("SET_LOADING", false);
        })
        .catch(error => {
          console.log(error);
          commit("SET_LOADING", false);
          commit("SET_FETCHING_SIMILARITY_ERROR", {
            isError: true,
            errorMsg:
              "Error getting services, please try againg later or contact support"
          });
        });
    }
  },
  getters: {
    similarCompounds: state => state.similarCompounds,
    totalCompounds: state => state.totalCompounds,
    isLoading: state => state.loading,
    errorFetching: state => state.errorFetching
  }
});
