<template>
  <v-card>
    <v-card-text>Draw your molecule</v-card-text>

    <MarvinJS :eventBus="eventBus" v-on:error="hadleSketcherError" v-on:molObtained="receiveMol"/>
    <v-card-actions class="justify-center">
      <v-btn
        dark
        color="primary"
        @click="triggerSearch"
        :disabled="disableSearch"
        :loading="loading"
      >Search</v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
import MarvinJS from "@/components/shared/MarvinSketcher";
import Vue from "vue";

export default {
  components: {
    MarvinJS
  },
  props: ["bus"],
  data() {
    return {
      loading: false,
      disableSearch: false,
      eventBus: new Vue() // this is to communicate with marvin and get the molecule drawn
    };
  },
  methods: {
    disableButtons() {
      this.disableSearch = true;
    },
    enableButtons() {
      this.disableSearch = false;
    },
    triggerSearch() {
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
      this.$emit('molObtained', currentMol)
    }
  }
};
</script>

<style lang="scss" scoped>
</style>