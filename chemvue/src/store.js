import Vue from "vue";
import Vuex from "vuex";
import Api from "@/services/Api.js";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    errorFetching: false,
    errorMessage: "",
    loading: true,
    similarCompounds: []
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
    },
    SET_ERROR_FETCHING(state, isError){
      console.log("Is error", isError);
      state.errorFetching = isError;
    },
    SET_ERROR_MESSAGE(state, message){
      state.errorMessage = message
    }
  },
  actions: {
    loadCountries: function({ commit }, payload) {
      let body = payload.body;
      console.log(body);
      commit("SET_LOADING", true);
      console.log("State loading ", this.state.loading);
      Api()
        .post("/similarity/", body)
        .then(similarCompounds => {
          if (similarCompounds.data.inchis.length <= 0) {
            console.log("No inchis");
            commit("SET_ERROR_FETCHING", true);
            commit("SET_ERROR_MESSAGE", similarCompounds.data.message)
          } else {
            commit("SET_ERROR_FETCHING", false);
            commit("SET_SIMILAR_COMPOUNDS", similarCompounds.data);
          }
          commit("SET_LOADING", false);
        })
        .catch(error => console.log(error));
    }
  },
  getters: {
    similarCompounds: state => state.similarCompounds,
    isLoading: state => state.loading,
    errorMessage: state => state.errorMessage,
    isErrorFetching: state => state.errorFetching,
  }
});
