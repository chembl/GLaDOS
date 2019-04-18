<template>
  <v-container>
    <v-layout align-start justify-start column>
      <v-dialog v-model="marvinModal" max-width="100%">
        <v-card>
          <v-toolbar flat>
            <v-toolbar-title>Marvin Editor</v-toolbar-title>
            <v-spacer></v-spacer>
            <v-btn icon @click="marvinModal = false">
              <v-icon>close</v-icon>
            </v-btn>
          </v-toolbar>
          <v-card-text>Draw your molecule</v-card-text>
          <MarvinJS
            v-bind:molecule="molecule"
            v-on:onSearch="onMarvinSearch"
          ></MarvinJS>
        </v-card>
      </v-dialog>
      <h1>Unichem</h1>
      <h3>Substructure Similarity Search</h3>
      <v-container>
        <v-flex xs12>
          <v-alert
            v-bind:value="isShowAlert"
            v-bind:type="alertBox.type"
            dark
            transition="scale-transition"
          >
            {{ alertBox.message }}
          </v-alert>
        </v-flex>

        <v-slider
          v-model="slider"
          label="Threshold"
          thumb-label
          min="70"
          max="100"
        ></v-slider>
        <v-layout align-center justify-center>
          <v-textarea
            name="input-7-1"
            label="CTAB/SMILES"
            value
            rows="1"
            hint="Place your CTAB/SMILES here"
            v-model="ctabText"
          ></v-textarea>
          <v-btn dark color="primary" @click="onSearch">
            <v-icon dark>mdi-database-search</v-icon><v-spacer></v-spacer>Search
          </v-btn>
          <v-btn color="primary" @click.stop="marvinModal = true">
            <v-icon dark>mdi-drawing</v-icon><v-spacer></v-spacer>Draw Mol
          </v-btn>
        </v-layout>
        <div v-if="molecule">
          <v-layout class="align-center justify-center column">
            <span class="title">Showing {{ compoundCount }} results for:</span>
            <v-tabs class="ma-2" color="primary" fixed-tabs>
              <v-tab ripple>
                Molecule
              </v-tab>
              <v-tab ripple v-if="smilesForm">
                SMILES
              </v-tab>
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
          </v-layout>
          <v-divider></v-divider>
        </div>
        <v-progress-circular
          v-if="isLoading"
          :size="70"
          :width="7"
          color="purple"
          indeterminate
        ></v-progress-circular>
        <Compounds
          v-bind:compoundList="retrievedCompounds"
          v-bind:compoundsTotal="compoundCount"
          v-bind:maxPerPage="maxPerPage"
          v-on:onPageChange="onPageChange"
        ></Compounds>
      </v-container>
    </v-layout>
  </v-container>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">
.searched-compound {
  max-height: 100px;
  overflow-y: scroll;
  backface-visibility: hidden;
}
</style>

<script>
import Vue from "vue";
import MarvinJS from "@/components/shared/Marvin";
import RestAPI from "@/services/Api";
import Compounds from "@/components/shared/Compounds";

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
      ctabText: "",
      marvinModal: false,
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
    onMarvinSearch: function(mol) {
      this.marvinModal = false;
      this.isShowAlert = false;
      this.smilesForm = "";

      this.molecule = mol;
      this.loadCompounds(this.molecule);
      this.getSMILESfromMOL(mol);
    },
    getSMILESfromMOL(mol) {
      var backendAPIs = new RestAPI();
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
      console.log("On page change", init);
      this.range = {
        init: init,
        end: init + this.maxPerPage
      };
      console.log(this.range);
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
    MarvinJS,
    Compounds
  }
});
</script>
