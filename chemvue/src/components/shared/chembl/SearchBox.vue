<template>
  <div id="BCK-SearchBarContainer" class="search-bar-container">
    <div id="chembl-header-search-bar-container" class="bar-wrapper">
      <input
        type="search"
        value
        name="search-str"
        class="chembl-search-bar"
        placeholder="Search in ChEMBL"
      >
      <a class="bar-button search-button">
        <img src="@/assets/img/icons/search_icon.png" />
      </a>
    </div>
    
    <div class="show-on-large-pin-top">
      <div class="search-examples">
        Examples:&nbsp;
        <a href="/g/#search_results/Dopamine">Dopamine</a>&nbsp;
        <a href="/g/#search_results/HepG2">HepG2</a>&nbsp;
        <a href="/g/#search_results/NAFRONYL">NAFRONYL</a>&nbsp;
        <a href="/g/#search_results/NCC(=O)Oc1ccccc1C(=O)O">NCC(=O)Oc1ccccc1C(=O)O</a>
      </div>
      <div class="special-searches">
        <a class="BCK-Draw-Structure">Draw a Structure</a>
        |
        <a class="BCK-Enter-Sequence">Enter a Sequence</a>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      links: [
        {
          label: "UniChem",
          url: "https://www.ebi.ac.uk/unichem"
        },
        {
          label: "SureChEMBL",
          url: "https://www.surechembl.org"
        }
      ]
    };
  },
  mounted() {},
  name: "SearchBox"
};
</script>

<style scoped lang="scss">
.search-bar-container {
  width: 100%;
  position: relative;

  .bar-wrapper {
    width: 100%;
    background-color: white;
    display: flex;

    -webkit-transition: height 200ms ease-in;
    transition: height 200ms ease-in;

    .chembl-search-bar {
      font-family: $helvetica;
      padding-left: $chembl-header-padding;
      margin: 0;
      height: 100%;
    }

    .special-searches-buttons-container {
      display: flex;
      padding: 0 5px;
      background-color: $chembl-teal;

      .bar-button:first-child {
        margin-right: 5px;
      }
    }

    .bar-button {
      padding: $chembl-header-padding;
      height: 100%;
      display: flex;
      justify-content: center;
      align-items: center;

      -webkit-transition: background-color 200ms ease-in-out;
      transition: background-color 200ms ease-in-out;

      img {
        height: auto;
        -webkit-transition: height, width 200ms ease-in;
        transition: height, width 200ms ease-in;
      }

      background-color: $darker-teal;
      &:hover {
        background-color: $lighter-teal;
      }
    }
  }

  .search-examples,
  .special-searches {
    font-family: $chembl-helvetica;
    color: white;
    font-size: 0.8em;
    margin-top: 0.5em;
    letter-spacing: 0.05em;
    width: 50%;

    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;

    a {
      color: white;

      &:hover {
        text-decoration: underline;
      }
    }
  }

  .search-examples {
    float: left;
    display: flex;

    a:last-child {
      display: inline-block;
      overflow: hidden;
      white-space: nowrap;
      text-overflow: ellipsis;
    }
  }
  .special-searches {
    float: right;
    text-align: right;
  }
}
</style>
