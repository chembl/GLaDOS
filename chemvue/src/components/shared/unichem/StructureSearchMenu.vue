<template>
  <v-card>
    <v-toolbar flat>
      <v-toolbar-title>Marvin Editor</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn icon @click="sketcherModal = false">
      <v-icon>close</v-icon>
      </v-btn>
    </v-toolbar>
    <v-card-text>Draw your molecule</v-card-text>
    <!-- <StructureSearchMenu
        v-bind:molecule="molecule"
        v-on:onSearch="onMarvinSearch"
    ></StructureSearchMenu> -->

  </v-card>
</template>

<script>
import MarvinJS from "@/components/shared/MarvinSketcher";
export default {
  components: {
    MarvinJS
  },
}
</script>

<style lang="scss" scoped>

</style>