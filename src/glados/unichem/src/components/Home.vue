<template>
    <v-container fluid>
        <v-slide-y-transition mode="out-in">
            <v-layout align-start justify-start column>
                <h1>Unichem</h1>
                <h3>Substructure Similarity Search</h3>
                <p>
                    {{countries}}
                </p>
            </v-layout>
        </v-slide-y-transition>
    </v-container>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">

</style>

<script>
import Vue from 'vue'

export default Vue.component('Home', {
  data () {
    return {
      page: 1
    }
  },
  created () {
  },
  beforeCreate () {
    let params = {
    }
    this.$store.dispatch('loadCountries', { 'params': params })
  },
  computed: {
    countries () {
      return this.$store.getters.countries
    }
  },
  methods: {
  },
  watch: {
  }
})
</script>