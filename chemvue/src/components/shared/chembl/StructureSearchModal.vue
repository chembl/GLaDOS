<template>
    <v-dialog
      v-model="dialog"
      width="500"
    >
      <template v-slot:activator="{ on }">
        <v-btn
          color="primary"
          dark
          v-on="on"
        >
          Structure Search
        </v-btn>
      </template>

      <v-card>
        <v-card-title
          class="headline grey lighten-2"
          primary-title
        >
          Draw a Structure
        </v-card-title>

        <MarvinJS :eventBus="eventBus" v-on:error="hadleSketcherError" />

        <v-divider></v-divider>

        <v-container>
          Search by: 
          <v-card-actions>

            <v-btn dark color="primary" 
              @click="triggerConnectivitySearch" 
              :disabled="disableConnectivity" 
              :loading="loading"
              >
              Connectivity
            </v-btn>
            <v-spacer></v-spacer>

            <v-btn 
              dark color="primary" 
              @click="triggerSimilaritySearch" 
              :disabled="disableSimilarity" 
              :loading="loading">
              Similarity
            </v-btn>
            
            <v-spacer></v-spacer>
            <v-btn 
              dark color="primary" 
              @click="triggerSubstructureSearch" 
              :disabled="disableSubstructure" 
              :loading="loading">
              Substructure
            </v-btn>
          </v-card-actions>
          <div v-if="loading" class="text-xs-center">Loading...</div>
        </v-container>
      </v-card>
    </v-dialog>
</template>

<script>
import MarvinJS from "@/components/shared/MarvinSketcher";
import Vue from "vue";

export default {
  components: {
    MarvinJS
  },
  props: ['bus'],
  data () {
    return {
      dialog: false,
      disableConnectivity: false,
      disableSimilarity: false,
      disableSubstructure: false,
      loading: false,
      eventBus: new Vue() // this is to communicate with marvin and get the smiles
    }
  },
  methods: {
    disableButtons () {
      this.disableConnectivity = true
      this.disableSimilarity = true
      this.disableSubstructure = true
    },
    enableButtons () {
      this.disableConnectivity = false
      this.disableSimilarity = false
      this.disableSubstructure = false
    },
    triggerConnectivitySearch() {
      // this.dialog = false remember to use this to close the modal
      console.log('TRIGGER CONNECTIVITY SEARCH')
      this.loading = true
      this.disableButtons()
      this.eventBus.$emit('getDrawnSmiles')
    },
    triggerSimilaritySearch() {
      console.log('TRIGGER Similarity SEARCH')
      this.loading = true
      this.disableButtons()
    },
    triggerSubstructureSearch() {
      console.log('TRIGGER Substructure SEARCH')
      this.loading = true
      this.disableButtons()
    },
    hadleSketcherError() {
      this.loading = false
      this.enableButtons()
    }
  }
}
</script>

<style lang="scss" scoped>

</style>