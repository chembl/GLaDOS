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

        <MarvinJS/>

        <v-divider></v-divider>

        <v-card-actions>

          <v-btn dark color="primary" @click="triggerConnectivitySearch">
            Connectivity
          </v-btn>
          <v-spacer></v-spacer>

          <v-btn dark color="primary" @click="triggerSimilaritySearch">
            Similarity
          </v-btn>
          
          <v-spacer></v-spacer>
          <v-btn dark color="primary" @click="triggerSubstructureSearch">
            Substructure
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
</template>

<script>
import MarvinJS from "@/components/shared/MarvinSketcher";

export default {
  components: {
    MarvinJS
  },
  data () {
    return {
      dialog: false
    }
  },
  methods: {
    triggerConnectivitySearch() {
      // this.dialog = false remember to use this to close the modal
      console.log('TRIGGER CONNECTIVITY SEARCH')
    },
    triggerSimilaritySearch() {
      console.log('TRIGGER Similarity SEARCH')

    },
    triggerSubstructureSearch() {
      console.log('TRIGGER Substructure SEARCH')
    }
  }
}
</script>

<style lang="scss" scoped>

</style>