<template>
  <v-container fluid>
    <div class="text-xs-center">
      <v-pagination
        v-if="renderedCompounds.length > 0"
        v-model="page"
        :length="pages"
        :total-visible="7"
      ></v-pagination>
    </div>
    <v-card
      v-for="(compound, index) in compounds"
      v-bind:compound="compound"
      :key="index"
      class="mt-3 pa-2 compound-card"
    >
      <v-layout justify-center wrap>
        <v-flex xs12 sm3>
          <div class="ma-3 pa-2 image-cont">
            <v-img :src="imgBasePath + compound.uci" contain />
          </div>
        </v-flex>
        <v-flex xs12 sm8>
          <v-card-title primary-title>
            <v-layout align-start row>
              <div class="title mb-0">UCI: {{ compound.uci }}</div>
              <v-spacer></v-spacer>
              <v-btn
                v-on:click="onDisplaySources(compound)"
                class="ml-4"
                color="primary"
              >
                <v-icon>mdi-file-tree</v-icon><v-spacer></v-spacer>Sources
              </v-btn>
            </v-layout>
            <div>
              <span class="subheading">Similarity</span>
              <span
                class="subheading  font-weight-bold"
                v-if="typeof compound.similarity !== 'undefined'"
              >
                {{ compound.similarity }}
              </span>
              <v-divider light></v-divider>
              <span class="subheading">Canonical SMILES</span>
              <span
                class="compound-property body-1 font-weight-light"
                v-if="typeof compound.smiles !== 'undefined'"
              >
                {{ compound.smiles }}
              </span>
              <v-divider light></v-divider>
              <span class="subheading">Standard InChI Key</span>
              <span
                class="compound-property body-1 font-weight-light"
                v-if="typeof compound.standardinchikey !== 'undefined'"
              >
                {{ compound.standardinchikey }}
              </span>
              <v-divider light></v-divider>
              <span class="subheading">Standard InChI</span>
              <span
                class="compound-property body-1 font-weight-light"
                v-if="typeof compound.standardinchi !== 'undefined'"
              >
                {{ compound.standardinchi }}
              </span>
              <v-divider light></v-divider>
            </div>
          </v-card-title>
        </v-flex>
      </v-layout>
      <transition name="slide-fade">
        <div class="detail pa-3" v-if="compound.show">
          <v-layout align-center justify-start row>
            <div class="property px-3 py-1">
              <v-chip v-for="(source, index) in compound.sources" :key="index">
                <a :href="source.url" target="_blank">
                  {{ source.nameLabel }} {{ source.id }}
                </a>
              </v-chip>
            </div>
            <v-alert
              :value="compound.sources.length < 1"
              type="error"
              dark
              transition="scale-transition"
              mt-2
            >
              NO SOURCES FOUND
            </v-alert>
          </v-layout>
        </div>
      </transition>
    </v-card>
  </v-container>
</template>

<script>
export default {
  props: ["compoundList", "compoundsTotal", "maxPerPage"],
  data() {
    return {
      compounds: this.compoundList,
      compoundCount: this.compoundsTotal,
      renderedCompounds: [],
      page: 1,
      pages: 0,
      pageMax: this.maxPerPage,
      imgBasePath: ""
    };
  },
  created() {
    this.imgBasePath = `${process.env.VUE_APP_ROOT_API}/${
      process.env.VUE_APP_SERVER_BASE_PATH
    }glados_api/chembl/unichem/images/`;
  },
  methods: {
    onDisplaySources(compound) {
      compound.show = !compound.show;
    }
  },
  watch: {
    compoundList() {
      this.compounds = this.compoundList;

      this.pageMax = this.maxPerPage;
      this.compoundCount = this.compoundsTotal;

      this.pages = Math.ceil(this.compoundCount / this.pageMax);
      this.renderedCompounds = this.compounds.slice(0, this.pageMax);
    },
    page: function(newVal) {
      let init = (newVal - 1) * this.pageMax;
      this.$emit("onPageChange", init);
    }
  },
  name: "Compounds",
  components: {}
};
</script>

<style scoped lang="scss">
.image-cont {
  background-color: $grey-lightest;
  border-radius: 100%;
}
.compound-property {
  word-break: break-all;
}
</style>
