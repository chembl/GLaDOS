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
        <v-btn color="info" @click.stop="marvinModal = true">Draw it!</v-btn>
        <v-layout align-center justify-center>
          <v-textarea
            name="input-7-1"
            label="CTAB/SMILES"
            auto-grow
            value
            rows="1"
            hint="Place your CTAB/SMILES here"
            v-model="ctabText"
          ></v-textarea>
          <v-btn dark color="primary" @click="onSearch">
            <v-icon dark>mdi-database-search</v-icon><v-spacer></v-spacer>Search
          </v-btn>
        </v-layout>
        <v-progress-circular
          v-if="isLoading"
          :size="70"
          :width="7"
          color="purple"
          indeterminate
        ></v-progress-circular>
        <!-- <v-layout align-space-around justify-center column fill-height>
          <v-card
            v-for="(compound, index) in similarCompounds"
            v-bind:compound="compound"
            :key="index"
            class="mt-3"
            raised
          >
            <v-card-title primary-title>
              <div>
                <h3 class="headline mb-0">{{ compound.uci }}</h3>
                <div v-if="typeof compound.similarity !== 'undefined'">
                  {{ compound.similarity }}
                </div>
                <img :src="urlImages + compound.uci" />
              </div>
              <v-layout align-center justify-end row fill-height>
                <v-btn
                  v-on:click="compound.show = !compound.show"
                  fab
                  dark
                  small
                  class="ml-4"
                >
                  <v-icon>mdi-arrow-down-drop-circle</v-icon>
                </v-btn>
              </v-layout>
            </v-card-title>

            <v-card-actions>
              <transition name="slide-fade">
                <div class="detail pa-3" v-if="compound.show">
                  <v-layout align-center justify-space-around row>
                    <div class="property px-3 py-1">
                      <div class="label">SMILES</div>
                      <div
                        class="value"
                        v-if="typeof compound.standardinchi !== 'undefined'"
                      >
                        {{ compound.standardinchi }}
                      </div>
                    </div>
                  </v-layout>
                </div>
              </transition>
            </v-card-actions>
          </v-card>
        </v-layout> -->
        <Compounds v-bind:compoundList="retrievedCompounds"></Compounds>
      </v-container>
    </v-layout>
  </v-container>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss"></style>

<script>
import Vue from "vue";
import MarvinJS from "@/components/shared/marvin";
import RestAPI from "@/services/Api";
import Compounds from "@/components/shared/Compounds";

export default Vue.component("Home", {
  data() {
    return {
      page: 1,
      ctabText: "",
      marvinModal: false,
      molecule: "",
      isShowAlert: false,
      alertBox: {
        type: "error",
        message: ""
      },
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
    }
  },
  methods: {
    getImage(smiles) {
      console.log("searching smile", smiles);
      let unichemApi = new RestAPI();
      let imageSVG = unichemApi
        .getImageFromSmile()
        .post("", smiles)
        .then(image => {
          return image.data;
        })
        .catch(error => console.log(error));
      return imageSVG;
    },
    loadCompounds(query) {
      this.$store.commit("SET_LOADING", true);
      this.$store.dispatch("loadCompounds", { query });
    },
    onSearch() {
      this.isShowAlert = false;
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
        this.loadCompounds(this.ctabText);
      }
    },
    onMarvinSearch: function(mol) {
      this.marvinModal = false;
      this.molecule = mol;
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
    }
  },
  components: {
    MarvinJS,
    Compounds
  }
});
</script>
