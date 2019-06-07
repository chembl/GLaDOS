<template>
  <v-container>
    <v-dialog v-model="sketcherModal" max-width="100%">
      <v-toolbar flat>
        <v-toolbar-title>Marvin Editor</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-btn icon @click="sketcherModal = false">
          <v-icon>close</v-icon>
        </v-btn>
      </v-toolbar>
      <StructureSearchMenu
        v-on:molObtained="handleMolObtained"
        v-bind:molecule="molecule"
      />
    </v-dialog>
    <h1>Unichem</h1>
    <h3>Substructure Similarity Search</h3>
    <v-alert
      v-bind:value="isShowAlert"
      v-bind:type="alertBox.type"
      dark
      transition="scale-transition"
      mt-2
      >{{ alertBox.message }}</v-alert
    >
    <v-layout align-center justify-space-around row wrap mb-2>
      <v-flex xs12 sm10>
        <v-slider
          v-model="slider"
          label="Threshold"
          thumb-label
          min="70"
          max="99"
        ></v-slider>
      </v-flex>
      <v-spacer></v-spacer>
      <v-flex xs12 sm2>
        <span class="title ml-5">
          {{ slider }}
          <v-icon>mdi-percent</v-icon>
        </span>
      </v-flex>
    </v-layout>
    <v-layout align-center justify-space-between row wrap mb-2>
      <v-flex xs12 sm8>
        <v-textarea
          name="input-7-1"
          label="CTAB/SMILES"
          rows="1"
          hint="Place your CTAB/SMILES here, e.g., NCCc1ccc(O)c(O)c1"
          v-model="ctabText"
        ></v-textarea>
      </v-flex>
      <v-flex xs6 sm2>
        <v-btn dark color="primary" @click="onSearch">
          <v-icon dark>mdi-database-search</v-icon>
          <v-spacer></v-spacer>Search
        </v-btn>
      </v-flex>
      <v-flex xs6 sm2>
        <v-btn color="primary" @click.stop="sketcherModal = true">
          <v-icon dark>mdi-drawing</v-icon>
          <v-spacer></v-spacer>Draw Mol
        </v-btn>
      </v-flex>
    </v-layout>

    <div v-if="molecule">
      <span class="title">Showing {{ compoundCount }} results for:</span>
      <v-tabs class="mt-3 mb-3 elevation-1" color="primary" fixed-tabs>
        <v-tab ripple>Molecule</v-tab>
        <v-tab ripple v-if="smilesForm">SMILES</v-tab>
        <v-tab-item>
          <v-card flat>
            <v-card-text class="pa-1 searched-compound">
              <pre>
                {{ molecule }}
              </pre>
            </v-card-text>
          </v-card>
        </v-tab-item>
        <v-tab-item v-if="smilesForm">
          <v-card flat>
            <v-card-text class="pa-1 searched-compound">
              <pre>
                {{ smilesForm }}
              </pre>
            </v-card-text>
          </v-card>
        </v-tab-item>
      </v-tabs>
      <v-divider></v-divider>
    </div>

    <v-progress-linear :active="isLoading" indeterminate></v-progress-linear>

    <Compounds
      v-bind:compoundList="retrievedCompounds"
      v-bind:compoundsTotal="compoundCount"
      v-bind:maxPerPage="maxPerPage"
      v-on:onPageChange="onPageChange"
    ></Compounds>
  </v-container>
</template>

<script>
import Vue from "vue";
import RestAPI from "@/services/Api";
import Compounds from "@/components/shared/Compounds";
import StructureSearchMenu from "@/components/shared/unichem/StructureSearchMenu.vue";

const backendAPIs = new RestAPI();

export default Vue.component("Home", {
  data() {
    return {
      slider: 90,
      threshold: 0.9,
      range: {
        init: 0,
        end: 10
      },
      page: 1,
      ctabText: "NCCc1ccc(O)c(O)c1",
      sketcherModal: false,
      molecule: "",
      smilesForm: "",
      isShowAlert: false,
      alertBox: {
        type: "error",
        message: ""
      },
      maxPerPage: 10,
      urlImages: "http://localhost:8000/glados_api/chembl/unichem/images/"
    };
  },
  created() {
    this.$store.commit("SET_LOADING", false);
    this.$store.commit("SET_FETCHING_SIMILARITY_ERROR", {
      isError: false,
      errorMsg: ""
    });
  },
  computed: {
    retrievedCompounds() {
      return this.$store.getters.similarCompounds;
    },
    isLoading() {
      return this.$store.getters.isLoading;
    },
    isFetchError() {
      return this.$store.getters.errorFetching.isError;
    },
    errorMessage() {
      return this.$store.getters.errorMessage;
    },
    compoundCount() {
      return this.$store.getters.totalCompounds;
    }
  },
  methods: {
    loadCompounds(query) {
      this.$store.commit("SET_LOADING", true);
      this.$store.dispatch("loadCompounds", {
        data: query,
        threshold: this.threshold,
        init: this.range.init,
        end: this.range.end
      });
    },
    onSearch() {
      this.isShowAlert = false;
      this.molecule = "";
      this.smilesForm = "";

      if (this.ctabText == "") {
        this.isShowAlert = true;
        this.alertBox = {
          type: "warning",
          message: "Need CTAB or SMILES for the search"
        };
      } else {
        this.$store.commit("SET_FETCHING_SIMILARITY_ERROR", {
          isError: false,
          errorMsg: ""
        });
        this.molecule = this.ctabText;
        this.loadCompounds(this.ctabText);
      }
    },
    handleMolObtained: function(mol) {
      this.sketcherModal = false;
      this.isShowAlert = false;
      this.smilesForm = "";
      this.ctabText = mol;
      this.molecule = mol;
      this.loadCompounds(this.molecule);
      this.getSMILESfromMOL(mol);
    },
    getSMILESfromMOL(mol) {
      backendAPIs
        .getBeakerAPI()
        .post("/ctab2smiles", mol)
        .then(res => {
          this.smilesForm = res.data;
        })
        .catch(error => {
          console.log(error);
        });
    },
    onPageChange(init) {
      this.range = {
        init: init,
        end: init + this.maxPerPage
      };
      this.loadCompounds(this.molecule);
    }
  },
  watch: {
    isFetchError: function() {
      var errorFetching = this.$store.getters.errorFetching;
      if (errorFetching.isError) {
        this.isShowAlert = true;
        this.alertBox = {
          type: "error",
          message: errorFetching.errorMsg
        };
      }
    },
    slider() {
      this.threshold = this.slider / 100;
    }
  },
  components: {
    StructureSearchMenu,
    Compounds
  }
});
</script>

<style scoped lang="scss">
.searched-compound {
  max-height: 100px;
  overflow-y: scroll;
  backface-visibility: hidden;
}
</style>
