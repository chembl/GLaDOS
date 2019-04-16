<template>
  <div class="marvin-iframe">
    <v-card flat>
      <v-alert v-model="alert" dismissible type="warning">
        {{ alertMessage }}
      </v-alert>
      <iframe
        id="marvin-iframe"
        ref="marvinSketcher"
        class="sketch-iframe"
        :src="marvinPath"
        allowfullscreen
      ></iframe>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="primary" @click="onSearchMolecule">
          Search
        </v-btn>
      </v-card-actions>
    </v-card>
  </div>
</template>

<script>
export default {
  props: ["molecule"],
  data() {
    return {
      // marvinPath: `${process.env.VUE_APP_ROOT_API}/static/marvinjs/editorws.html
      alert: false,
      alertMessage: "",
      marvinPath: `/marvinjs/editorws.html`,
      marvinEditor: {},
      currentMolecule: this.molecule,
      isEditorEmpty: true
    };
  },
  mounted() {
    // eslint-disable-next-line
    MarvinJSUtil.getEditor("marvin-iframe").then(
      sketcher => {
        this.marvinEditor = sketcher;
      },
      err => alert(err)
    );
  },
  methods: {
    onSearchMolecule() {
      this.isEditorEmpty = this.marvinEditor.isEmpty();

      if (this.isEditorEmpty) {
        this.alert = true;
        this.alertMessage = "The editor is empty";
      } else {
        this.alert = false;
        this.marvinEditor.exportStructure("mol").then(
          mol => {
            this.currentMolecule = mol;
            this.$emit("onSearch", this.currentMolecule);
          },
          err => alert(err)
        );
      }
    }
  },
  name: "Header",
  components: {}
};
</script>

<style scoped lang="scss">
.sketch-iframe {
  overflow: hidden;
  min-width: 360px;
  min-height: 450px;
  width: 100%;
  border: 1px solid darkgray;
}
</style>
