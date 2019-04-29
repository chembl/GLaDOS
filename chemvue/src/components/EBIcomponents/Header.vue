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
  name: "EBIHeader"
};
</script>

<style scoped lang="scss">
@import "@/assets/sass/ebi/ebi-global.scss";

// @import "@/assets/sass/ebi/ebi-global.scss";

// // Fundation
// .clearfix::before,
// .clearfix::after {
//   display: table;
//   content: " ";
// }

// .clearfix::after {
//   clear: both;
// }

// .row {
//   max-width: 80rem;
//   margin-right: auto;
//   margin-left: auto;
// }
// .row::before,
// .row::after {
//   display: table;
//   content: " ";
// }
// .row::after {
//   clear: both;
// }
// .row.collapse > .column,
// .row.collapse > .columns {
//   padding-right: 0;
//   padding-left: 0;
// }
// .row .row {
//   margin-right: -0.625rem;
//   margin-left: -0.625rem;
// }
// @media print, screen and (min-width: 40em) {
//   .row .row {
//     margin-right: -0.9375rem;
//     margin-left: -0.9375rem;
//   }
// }
// @media print, screen and (min-width: 64em) {
//   .row .row {
//     margin-right: -0.9375rem;
//     margin-left: -0.9375rem;
//   }
// }
// .row .row.collapse {
//   margin-right: 0;
//   margin-left: 0;
// }
// .row.expanded {
//   max-width: none;
// }
// .row.expanded .row {
//   margin-right: auto;
//   margin-left: auto;
// }
// .row:not(.expanded) .row {
//   max-width: none;
// }
// .row.gutter-small > .column,
// .row.gutter-small > .columns {
//   padding-right: 0.625rem;
//   padding-left: 0.625rem;
// }
// .row.gutter-medium > .column,
// .row.gutter-medium > .columns {
//   padding-right: 0.9375rem;
//   padding-left: 0.9375rem;
// }

// .column,
// .columns {
//   width: 100%;
//   float: left;
//   padding-right: 0.625rem;
//   padding-left: 0.625rem;
// }
// @media print, screen and (min-width: 40em) {
//   .column,
//   .columns {
//     padding-right: 0.9375rem;
//     padding-left: 0.9375rem;
//   }
// }
// .column,
// .columns,
// .column:last-child:not(:first-child),
// .columns:last-child:not(:first-child) {
//   float: left;
//   clear: none;
// }
// .column:last-child:not(:first-child),
// .columns:last-child:not(:first-child) {
//   float: right;
// }
// .column.end:last-child:last-child,
// .end.columns:last-child:last-child {
//   float: left;
// }

// .column.row.row,
// .row.row.columns {
//   float: none;
// }

// .row .column.row.row,
// .row .row.row.columns {
//   margin-right: 0;
//   margin-left: 0;
//   padding-right: 0;
//   padding-left: 0;
// }

// .menu {
//   padding: 0;
//   margin: 0;
//   list-style: none;
//   position: relative;
// }

// .text-right {
//   text-align: right;
// }

// li {
//   border-right: none;
//   display: inline-block;
// }

// a {
//   color: white;
//   border-bottom: none;
//   cursor: pointer;
//   background-color: transparent;
//   line-height: 1;
//   text-decoration: none;
//   display: block;
//   padding: 0.7rem 1rem;
// }
</style>
