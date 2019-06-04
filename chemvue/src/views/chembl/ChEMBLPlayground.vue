<template>
  <v-container fluid class="container-story">
    <v-slide-y-transition mode="out-in">
      <h1>Hello World</h1>
    </v-slide-y-transition>
  </v-container>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1,
h2 {
  font-weight: normal;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}

.container-story {
  max-height: 100vh;
  overflow: auto;
}
</style>

<script>
import Vue from "vue";
export default {};
</script>
