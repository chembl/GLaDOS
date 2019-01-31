<template>
  <v-container>
    <v-layout align-start justify-start column>
      <h1>ChEMBL</h1>
      <h3>Substructure Similarity Search</h3>
      <v-container>
        <v-layout align-center justify-center>
          <v-textarea
            name="input-7-1"
            label="CTAB"
            value
            hint="Place your CTAB here"
            v-model="ctabText"
          ></v-textarea>
          <v-btn fab dark color="primary" v-on:click="loadCompounds">
            <v-icon dark>add</v-icon>
          </v-btn>
        </v-layout>
        <v-progress-circular v-if="isLoading" :size="70" :width="7" color="purple" indeterminate></v-progress-circular>
        <v-layout align-space-around justify-center column fill-height>
          <v-card
            v-for="(compound, index) in similarCompounds"
            v-bind:compound="compound"
            :key="index"
            class="mt-3"
            raised
          >
            <v-card-title primary-title>
              <div>
                <h3 class="headline mb-0">{{compound.n_parent}}</h3>
                <div v-if="typeof compound.inchikey !== 'undefined'">{{compound.inchikey}}</div>
              </div>
              <v-layout align-center justify-end row fill-height>
                <v-btn v-on:click="compound.show = !compound.show" fab dark small class="ml-4">
                  <v-icon>mdi-arrow-down-drop-circle</v-icon>
                </v-btn>
              </v-layout>
            </v-card-title>

            <v-card-actions>
              <transition name="slide-fade">
                <div class="detail pa-3" v-if="compound.show">
                  <v-layout align-center justify-space-around row>
                    <div class="property px-3 py-1">
                      <div class="label">SMILES</div>
                      <div
                        class="value"
                        v-if="typeof compound.smiles !== 'undefined'"
                      >{{compound.smiles}}</div>
                    </div>
                  </v-layout>
                </div>
              </transition>
            </v-card-actions>
          </v-card>
        </v-layout>
      </v-container>
    </v-layout>
  </v-container>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">
</style>

<script>
import Vue from "vue";

export default Vue.component("Home", {
  data() {
    return {
      page: 1,
      ctabText: ""
    };
  },
  created() {
    this.$store.commit("SET_LOADING", false);
  },
  // beforeCreate () {
  //   let body = this.ctabtext
  //   this.$store.dispatch('loadCountries', { body })
  // },
  computed: {
    similarCompounds() {
      return this.$store.getters.similarCompounds;
    },
    isLoading() {
      return this.$store.getters.isLoading;
    }
  },
  methods: {
    loadCompounds() {
      this.$store.commit("SET_LOADING", true);
      let body = this.ctabText;
      this.$store.dispatch("loadCountries", { body });
      console.log("LOADING... ", this.$store.state.loading);
    }
  },
  watch: {
    similarCompounds: function() {
      console.log("CHanged similarCompounds");
    }
  }
});
</script>