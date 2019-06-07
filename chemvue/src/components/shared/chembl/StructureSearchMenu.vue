<template>
  <v-card>
    <v-card-title class="headline grey lighten-2" primary-title>
      Draw a Structure
    </v-card-title>

    <MarvinJS
      :eventBus="eventBus"
      v-on:error="hadleSketcherError"
      v-on:molObtained="receiveMol"
    />

    <v-divider></v-divider>

    <v-container>
      Search by:
      <v-card-actions>
        <v-btn
          dark
          color="primary"
          @click="triggerConnectivitySearch"
          :disabled="disableConnectivity"
          :loading="loading"
        >
          Connectivity
        </v-btn>
        <v-spacer></v-spacer>

        <v-btn
          dark
          color="primary"
          @click="triggerSimilaritySearch"
          :disabled="disableSimilarity"
          :loading="loading"
        >
          Similarity
        </v-btn>

        <v-spacer></v-spacer>
        <v-btn
          dark
          color="primary"
          @click="triggerSubstructureSearch"
          :disabled="disableSubstructure"
          :loading="loading"
        >
          Substructure
        </v-btn>
      </v-card-actions>
      <div v-if="loading" class="text-xs-center">Loading...</div>
    </v-container>
  </v-card>
</template>

<script>
import MarvinJS from "@/components/shared/MarvinSketcher";
import Vue from "vue";

const SIMILARITY = "SIMILARITY";
const SUBSTRUCTURE = "SUBSTRUCTURE";
const CONNECTIVITY = "CONNECTIVITY";

export default {
  components: {
    MarvinJS
  },
  props: ["bus"],
  data() {
    return {
      disableConnectivity: false,
      disableSimilarity: false,
      disableSubstructure: false,
      loading: false,
      eventBus: new Vue(), // this is to communicate with marvin and get the molecule drawn
      selectedSearchType: "",
      searchTypes: { SIMILARITY, SUBSTRUCTURE, CONNECTIVITY }
    };
  },
  methods: {
    disableButtons() {
      this.disableConnectivity = true;
      this.disableSimilarity = true;
      this.disableSubstructure = true;
    },
    enableButtons() {
      this.disableConnectivity = false;
      this.disableSimilarity = false;
      this.disableSubstructure = false;
    },
    triggerConnectivitySearch() {
      this.selectedSearchType = this.searchTypes.CONNECTIVITY;
      this.loading = true;
      this.disableButtons();
      this.eventBus.$emit("getDrawnMol");
    },
    triggerSimilaritySearch() {
      this.selectedSearchType = this.searchTypes.SIMILARITY;
      this.loading = true;
      this.disableButtons();
      this.eventBus.$emit("getDrawnMol");
    },
    triggerSubstructureSearch() {
      this.selectedSearchType = this.searchTypes.SUBSTRUCTURE;
      this.loading = true;
      this.disableButtons();
      this.eventBus.$emit("getDrawnMol");
    },
    hadleSketcherError() {
      this.loading = false;
      this.enableButtons();
    },
    receiveMol(currentMol) {
      this.loading = false;
      this.enableButtons();
      this.$emit("searching");
      console.log("mol was recevied from outside", currentMol);
      console.log("TODO: Here I do a search...");
    }
  }
};
</script>

<style lang="scss" scoped></style>
