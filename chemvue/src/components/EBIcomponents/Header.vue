<template>
  <header id="masthead-black-bar" class="clearfix masthead-black-bar">
    <div>
      <nav class="row">
        <ul id="global-nav" class="menu global-nav text-right">
          <li class="home-mobile">
            <a href="https://www.ebi.ac.uk"></a>
          </li>
          <li class="where embl hide">
            <a href="http://www.embl.org">EMBL</a>
          </li>
          <li class="where barcelona hide">
            <a href="#">Barcelona</a>
          </li>
          <li class="where hamburg hide">
            <a href="#">Hamburg</a>
          </li>
          <li class="where grenoble hide">
            <a href="#">Heidelberg</a>
          </li>
          <li class="where grenoble hide">
            <a href="#">Grenoble</a>
          </li>
          <li class="where rome hide">
            <a href="#">Rome</a>
          </li>
          <li
            id="embl-selector"
            class="float-right show-for-medium embl-selector embl-ebi"
          >
            <button class="button float-right">&nbsp;</button>
          </li>
          <li class="float-right search">
            <a href="#" class="inline-block collpased float-left search-toggle">
              <span class="show-for-small-only">Search</span>
            </a>
          </li>
          <li class="what about">
            <a href="https://www.ebi.ac.uk/about">About us</a>
          </li>
          <li class="what training">
            <a href="https://www.ebi.ac.uk/training">Training</a>
          </li>
          <li class="what research">
            <a href="https://www.ebi.ac.uk/research">Research</a>
          </li>
          <li class="what services">
            <a href="https://www.ebi.ac.uk/services">Services</a>
          </li>
          <li class="where ebi">
            <a href="https://www.ebi.ac.uk">EMBL-EBI</a>
          </li>
        </ul>
      </nav>
    </div>
  </header>
</template>

<script>
export default {
  mounted() {
    // // eslint-disable-next-line
    // ebiFrameworkPopulateBlackBar();
  },
  name: 'EBIHeader'
};
</script>

<style scoped lang="scss">
@import '@/assets/sass/ebi/ebi-global.scss';
</style>
