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
    </v-card>
  </div>
</template>

<script>
// eslint-disable-next-line
import marv from "@/assets/marvin/marvinjslauncher.js";

export default {
  props: ["molecule", "eventBus"],
  data() {
    return {
      alert: false,
      alertMessage: "",
      // marvinPath: `${
      //   process.env.VUE_APP_ROOT_API
      // }/static/marvinjs/editorws.html`,
      marvinPath: "",
      marvinEditor: {},
      currentMol: this.molecule,
      isEditorEmpty: true
    };
  },
  created() {
    this.marvinPath = `${
      process.env.VUE_APP_PUBLIC_PATH
    }marvinjs/editorws.html`;
  },
  mounted() {
    // eslint-disable-next-line
    MarvinJSUtil.getEditor("marvin-iframe").then(
      sketcher => {
        this.marvinEditor = sketcher;
      },
      err => alert(err)
    );
    this.eventBus.$on("getDrawnMol", this.getDrawnMol);
  },
  methods: {
    getDrawnMol() {
      this.isEditorEmpty = this.marvinEditor.isEmpty();

      if (this.isEditorEmpty) {
        this.alert = true;
        this.alertMessage = "The editor is empty";
        this.$emit("error");
      } else {
        this.alert = false;
        this.marvinEditor.exportStructure("mol").then(
          mol => {
            this.currentMol = mol;
            this.$emit("molObtained", this.currentMol);
          },
          err => (this.alertMessage = "Marvin export estructure error: " + err)
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
