<template>
  <div class="sticky-container">
    <div class="masthead-inner row">
      <div class="columns medium-7" id="local-title">
        <h1>
          <a href="/" title="Back to ChEMBL homepage">ChEMBL</a>
        </h1>
      </div>
      <!-- local-nav -->
      <nav class="columns">
        <ul
          id="local-nav"
          class="dropdown menu float-left"
          data-description="navigational"
          data-dropdown-menu
        >
          <li class="active">
            <a href="/" class="active">Test</a>
          </li>
        </ul>
      </nav>
      <!-- /local-nav -->
    </div>
  </div>
</template>

<script>
// import * as ebiscript from "../../assets/ebi-feeling/js/script.js";
// ebiFrameworkPopulateBlackBar();
export default {
  name: "Header"
};
</script>

<style scoped lang="scss"></style>
