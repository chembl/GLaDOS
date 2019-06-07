<template>
  <div id="masthead" class="masthead">
    <div class="masthead-inner row">
      <v-container fluid>
        <v-layout row fill-height wrap>
          <v-flex xs12 md4 class="chembl-logo hidden-xs-and-down">
            <a href="/">
              <img src="@/assets/img/icons/chembl_logo_pink.png" />
              <span class="white-text">ChEMBL</span>
            </a>
          </v-flex>
          <v-flex xs12 md8 class="search-bar">
            <SearchBox></SearchBox>
          </v-flex>
        </v-layout>
      </v-container>

      <!-- local-nav -->
      <nav class="columns">
        <ul
          id="local-nav"
          class="dropdown menu float-left"
          data-description="navigational"
          data-dropdown-menu
        >
          <li v-for="item in links" :key="item.label">
            <a :href="item.url">{{ item.label }}</a>
          </li>
        </ul>
      </nav>
      <!-- /local-nav -->
    </div>
  </div>
</template>

<script>
import SearchBox from './SearchBox';

export default {
  data() {
    return {
      links: [
        {
          label: 'UniChem',
          url: 'https://www.ebi.ac.uk/unichem'
        },
        {
          label: 'SureChEMBL',
          url: 'https://www.surechembl.org'
        }
      ]
    };
  },
  mounted() {
    // eslint-disable-next-line
    ebiFrameworkAssignImageByMetaTags();
  },
  name: 'Header',
  components: {
    SearchBox
  }
};
</script>

<style scoped lang="scss">
#masthead {
  //header
  $side-buttons-width-big: 180px;
  $row-height-xl: 40px;
  $logo-height-xl: 50px;

  background-color: $chembl-teal;
  width: 100%;
  position: relative;
  float: left;

  -webkit-transition: all 200ms ease-in;
  transition: all 200ms ease-in;

  .chembl-logo {
    a {
      text-decoration: none;
    }

    img {
      width: 5em;
      height: auto;
    }

    span {
      padding-left: $chembl-header-padding;
      padding-top: $chembl-header-padding;
      font-family: $chembl-helvetica;
      font-size: 3em;
    }

    /* -------- SMALL SCREEN -------- */
    @media (max-width: 600px) {
      span {
        font-size: 30px;
      }
    }
  }

  .search-bar {
    height: $chembl-header-height;
    padding: $chembl-header-padding;

    -webkit-transition: max-width 300ms ease-in;
    transition: max-width 300ms ease-in;
  }
}
</style>
