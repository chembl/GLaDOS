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
          Click Me
        </v-btn>
      </template>

      <v-card>
        <v-card-title
          class="headline grey lighten-2"
          primary-title
        >
          Draw a Structure
        </v-card-title>

        <v-card-text>
          Editor comes here!
        </v-card-text>

        <v-divider></v-divider>

        <v-card-actions>

          <v-btn dark color="primary" @click="dialog = false" >
            Connectivity
          </v-btn>
          <v-spacer></v-spacer>

          <v-btn dark color="primary" @click="dialog = false">
            Similarity
          </v-btn>
          
          <v-spacer></v-spacer>
          <v-btn dark color="primary" @click="dialog = false">
            Substructure
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
</template>

<script>
export default {
  data () {
    return {
      dialog: false
    }
  }
}
</script>

<style lang="scss" scoped>

</style>