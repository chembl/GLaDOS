<template>
  <v-container fluid class="container-story">
    Structure search modal:
    <br />

    <v-dialog v-model="dialog" width="90%">
      <StructureSearchMenu v-on:searching="closeModal" />
      <template v-slot:activator="{ on }">
        <v-btn color="primary" dark v-on="on">
          Structure Search
        </v-btn>
      </template>
    </v-dialog>
  </v-container>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped></style>

<script>
import StructureSearchMenu from '@/components/shared/chembl/StructureSearchMenu.vue';
export default {
  components: {
    StructureSearchMenu
  },
  data() {
    return {
      dialog: false
    };
  },
  methods: {
    closeModal() {
      this.dialog = false;
    }
  }
};
</script>
