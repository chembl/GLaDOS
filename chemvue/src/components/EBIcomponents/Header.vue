<template>
  <header id="masthead-black-bar" class="clearfix masthead-black-bar"></header>
</template>

<script>
// import * as ebiscript from "../../assets/ebi-feeling/js/script.js";
// ebiFrameworkPopulateBlackBar();
export default {
  name: "EBIHeader",
  mounted() {
    // eslint-disable-next-line
    ebiFrameworkPopulateBlackBar();
  }
};
</script>

<style scoped lang="scss"></style>
