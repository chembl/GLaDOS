<template>
  <div class="header">
    <div class="header-inner">
      <v-layout row fill-height wrap>
        <v-flex xs12 md4 class="chembl-logo">
          <a href="/">
            <img src="@/assets/img/icons/chembl_logo_pink.png" />
            <span class="white-text">ChEMBL</span>
          </a>
        </v-flex>
      </v-layout>
      <!-- local-nav -->
      <v-layout row align-center class="hidden-sm-and-down pt-2">
        <ul class="header-nav-links">
          <li class="nav-link" v-for="item in links" :key="item.label">
            <a :href="item.url">{{ item.label }}</a>
          </li>
        </ul>
      </v-layout>
      <!-- /local-nav -->
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      links: [
        {
          label: 'UniChem',
          url: 'https://www.ebi.ac.uk/unichem'
        },
        {
          label: 'ChEMBL-NTD',
          url: 'https://www.ebi.ac.uk/chembl/chembl-ntd/'
        },
        {
          label: 'SureChEMBL',
          url: 'https://www.surechembl.org'
        },
        {
          label: 'Downloads',
          url: 'https://www.ebi.ac.uk/chembl/downloads/'
        },
        {
          label: 'Web Services',
          url: 'https://www.ebi.ac.uk/chembl/ws_home/'
        },
        {
          label: 'Old Interface',
          url: 'https://www.ebi.ac.uk/chembl/deprecated_interface/'
        }
      ]
    };
  },
  mounted() {
    // // eslint-disable-next-line
    // ebiFrameworkAssignImageByMetaTags();
  },
  name: 'Header',
  components: {}
};
</script>

<style scoped lang="scss">
a {
  text-decoration: none;
}

.header {
  //header
  $side-buttons-width-big: 180px;
  $row-height-xl: 40px;
  $logo-height-xl: 50px;

  background-color: $chembl-teal;
  -webkit-transition: all 200ms ease-in;
  transition: all 200ms ease-in;

  background-repeat: no-repeat;
  background-position: 100% 82%;
  background-size: cover;
  background-image: url('data:image/svg+xml;charset=UTF-8,<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="147 248 60 248" xml:space="preserve"><polygon class="st0" fill="%23000" fill-opacity="0.05" points="147,363.6 259.3,363.6 259.3,428.4 203.2,460.9 147,428.4 "/></svg>');

  .header-inner {
    padding-top: 2.5rem;
    color: #fff;
    .chembl-logo {
      padding-left: 20px;

      a {
        color: white;
        border-bottom: none;
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
    }
    .header-nav-links {
      margin-top: 0;
      margin-bottom: 0;
      display: flex;
      list-style-type: none;

      .nav-link {
        border-right: solid white 1px;
        font-size: 0.8em;
        font-family: $verdana;
        letter-spacing: 0.1em;

        -webkit-transition: background-color 400ms ease-in-out;
        transition: background-color 400ms ease-in-out;

        a {
          display: block;
          width: 100%;
          height: 100%;

          color: white;
          padding: 5px 20px;
        }
      }
    }
  }
}
</style>
