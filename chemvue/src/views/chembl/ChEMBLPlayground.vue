<template>
  <v-container fluid class="container-story">

    Structure search modal:
    <br>
    <StructureSearchModal/>


  </v-container>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>

<script>
import StructureSearchModal from '@/components/shared/chembl/StructureSearchModal.vue'
export default {
    components: {
      StructureSearchModal
    }
}
</script>
