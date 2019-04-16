import Vue from "vue";
import Vuex from "vuex";
import RestAPI from "@/services/Api";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    errorFetching: {},
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
    SET_FETCHING_SIMILARITY_ERROR(state, error) {
      state.errorFetching = error;
    }
  },
  actions: {
    loadCompounds: function({ commit }, payload) {
      let body = payload.body;
      commit("SET_LOADING", true);
      //TO DO: Make this a general state variable
      var unichemApi = new RestAPI();
      unichemApi
        .getSimilarity()
        .post("/similarity/", body)
        .then(similarCompounds => {
          if (similarCompounds.data.inchis.length <= 0) {
            console.log("No inchis");
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
        .catch(error => console.log(error));
    }
  },
  getters: {
    similarCompounds: state => state.similarCompounds,
    isLoading: state => state.loading,
    errorFetching: state => state.errorFetching
  }
});
