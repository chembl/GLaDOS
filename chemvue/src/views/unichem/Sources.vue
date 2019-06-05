<template>
  <v-container>
    <v-dialog v-model="marvinModal" max-width="100%">

        <v-toolbar flat>
          <v-toolbar-title>Marvin Editor</v-toolbar-title>
          <v-spacer></v-spacer>
          <v-btn icon @click="marvinModal = false">
            <v-icon>close</v-icon>
          </v-btn>
        </v-toolbar>
        <StructureSearchMenu v-on:molObtained="handleMolObtained" v-bind:molecule="molecule"/>

    </v-dialog>
    <h1>Unichem</h1>
    <h3>Sources search</h3>
    <v-alert
      v-bind:value="isShowAlert"
      v-bind:type="alertBox.type"
      dark
      transition="scale-transition"
      mt-2
    >
      {{ alertBox.message }}
    </v-alert>

    <v-layout align-center justify-space-between row wrap mb-2>
      <v-flex xs12 sm8>
        <v-textarea
          name="inchiKeyBox"
          label="Standard InChI Key"
          rows="1"
          hint="Place your Standard InChI Key, e.g., HMCCXLBXIJMERM-UHFFFAOYSA-N"
          v-model="inchiKeyBox"
        ></v-textarea>
      </v-flex>
      <v-flex xs6 sm2>
        <v-btn dark color="primary" @click="onSearch">
          <v-icon dark>mdi-database-search</v-icon><v-spacer></v-spacer>Search
        </v-btn>
      </v-flex>
      <v-flex xs6 sm2>
        <v-btn color="primary" @click.stop="marvinModal = true">
          <v-icon dark>mdi-drawing</v-icon><v-spacer></v-spacer>Draw Mol
        </v-btn>
      </v-flex>
    </v-layout>

    <div v-if="molecule">
      <span class="title">Showing results for:</span>
      <v-tabs class="mt-3 mb-3 elevation-1" color="primary" fixed-tabs>
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
      <v-divider></v-divider>
    </div>

    <div v-if="isShowTable">
      <v-data-table
        :headers="headers"
        :items="sources"
        :loading="isLoading"
        class="elevation-1"
      >
        <v-progress-linear
          v-slot:progress
          color="primary"
          indeterminate
        ></v-progress-linear>
        <template v-slot:items="props">
          <td>
            <a :href="props.item.url">{{ props.item.id }}</a>
          </td>
          <td class="text-xs-right">{{ props.item.nameLabel }}</td>
          <td class="text-xs-right">{{ props.item.srcId }}</td>
        </template>
      </v-data-table>
    </div>
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
import StructureSearchMenu from "@/components/shared/unichem/StructureSearchMenu.vue";

const backendAPIs = new RestAPI();

export default Vue.component("Home", {
  data() {
    return {
      inchiKeyBox: "HMCCXLBXIJMERM-UHFFFAOYSA-N",
      marvinModal: false,
      molecule: "",
      smilesForm: "",
      isShowAlert: false,
      isSources: false,
      alertBox: {
        type: "error",
        message: ""
      },
      urlImages: "http://localhost:8000/glados_api/chembl/unichem/images/",
      sources: [],
      headers: [
        {
          text: "ID on source",
          align: "left",
          value: "id"
        },
        { text: "Source Name", value: "nameLabel" },
        { text: "Unichem Source ID", value: "srcId" }
      ],
      isShowTable: false,
      isLoading: false
    };
  },
  created() {},
  computed: {},
  methods: {
    loadSources(inchiKey) {
      this.isShowTable = true;
      this.isLoading = true;
      backendAPIs
        .getGLaDOSAPI()
        .get(`/sources/${inchiKey}`)
        .then(res => {
          this.sources = res.data.sources;
          this.isLoading = false;
          if (res.data.message) {
            this.showAlert(
              "warning",
              `No data found on Unichem for the compound given`
            );
            this.hideTable();
          }
        })
        .catch(error => {
          this.hideTable();
          console.log(error);
          this.showAlert(
            "error",
            "Error getting sources service, please try againg later or contact support"
          );
        });
    },
    onSearch() {
      this.resetFields();

      if (this.inchiKeyBox == "") {
        this.showAlert("warning", "Need CTAB or SMILES for the search");
        this.hideTable();
      } else {
        this.molecule = this.inchiKeyBox;
        this.loadSources(this.molecule);
        this.getSMILESfromMOL(this.molecule);
      }
    },
    handleMolObtained: function(mol) {
      this.resetFields();

      this.marvinModal = false;
      this.inchiKeyBox = mol;
      this.molecule = mol;
      this.getInchiKeyfromMOL(this.molecule)
        .then(res => {
          this.loadSources(res.data);
        })
        .catch(error => {
          this.hideTable();
          this.showAlert("error", "Error parsing InchiKey to MOL");
          console.log(error);
        });
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
    getInchiKeyfromMOL(mol) {
      return backendAPIs
        .getBeakerAPI()
        .post("/ctab2inchiKey", mol)
        .then(res => {
          return res;
        })
        .catch(error => {
          console.log(error);
        });
    },
    showAlert(type, message) {
      this.isShowAlert = true;
      this.alertBox = {
        type: type,
        message: message
      };
    },
    hideTable() {
      this.isShowTable = false;
      this.isLoading = false;
    },
    resetFields() {
      this.isShowAlert = false;
      this.smilesForm = "";
      this.molecule = "";
      this.sources = [];
    }
  },
  watch: {},
  components: {
    MarvinJS,
    StructureSearchMenu
  }
});
</script>
