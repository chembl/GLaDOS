<template>
  <v-layout align-space-around justify-center column>
    <v-card
      v-for="(compound, index) in compounds"
      v-bind:compound="compound"
      :key="index"
      class="mt-3 pa-2 compound-card"
    >
      <v-layout wrap>
        <v-flex xs12 sm4>
          <div class="mt-3 ml-3 pa-2 image-cont">
            <v-img
              :src="imgBasePath + compound.uci"
              contain
            />
          </div>
        </v-flex>
        <v-flex xs12 sm8>
          <v-card-title primary-title>
            <v-layout align-start row>
              <h3 class="headline mb-0">UCI: {{ compound.uci }}</h3>
              <v-spacer></v-spacer>
              <v-btn
                v-on:click="compound.show = !compound.show"
                class="ml-4"
                color="primary"
              >
                <v-icon>mdi-file-tree</v-icon><v-spacer></v-spacer>Sources
              </v-btn>
            </v-layout>
            <div>
              <div v-if="typeof compound.similarity !== 'undefined'">
                Similarity: {{ compound.similarity }}
              </div>
              <v-divider light></v-divider>
              <div class="value" v-if="typeof compound.smiles !== 'undefined'">
                SMILES: {{ compound.smiles }}
              </div>
              <v-divider light></v-divider>
              <!-- <div
                class="value"
                v-if="typeof compound.standardinchi !== 'undefined'"
              >
                Inchi: {{ compound.standardinchi }}
              </div>
              <v-divider light></v-divider> -->
              <div
                class="value"
                v-if="typeof compound.standardinchikey !== 'undefined'"
              >
                Standard Inchi: {{ compound.standardinchikey }}
              </div>
            </div>
          </v-card-title>
        </v-flex>
      </v-layout>
      <transition name="slide-fade">
        <div class="detail pa-3" v-if="compound.show">
          <v-layout align-center justify-start row>
            <div class="property px-3 py-1">
              <div class="label">Sources</div>
            </div>
          </v-layout>
        </div>
      </transition>
    </v-card>
  </v-layout>
</template>

<script>
export default {
  props: ["compoundList"],
  data() {
    return {
      compounds: this.compoundList,
      imgBasePath: "http://localhost:8000/glados_api/chembl/unichem/images/"
    };
  },
  mounted() {},
  methods: {},
  watch: {
    compoundList() {
      this.compounds = this.compoundList;
    }
  },
  name: "Compounds",
  components: {}
};
</script>

<style scoped lang="scss">
.image-cont {
  background-color: $teal-6;
  border-radius: 100%;
}
</style>
