const path = require("path");
const yaml = require("js-yaml");
const fs = require("fs");

process.env.VUE_APP_SERVER_BASE_PATH = process.env.SERVER_BASE_PATH
  ? process.env.SERVER_BASE_PATH + "/"
  : "";

let gladosConfigFile = process.env.CONFIG_FILE_PATH
  ? process.env.CONFIG_FILE_PATH
  : `${process.env.HOME}/.chembl-glados/config.yml`;
let gladosConfig = yaml.safeLoad(fs.readFileSync(gladosConfigFile));

if (typeof gladosConfig.chemvue_root_api === "undefined") {
  throw {
    name: "unichemapi not found",
    level: "FATAL",
    message: `API string (unichemapi) on config file ${gladosConfigFile} was not found`,
    toString: function() {
      return this.name + ": " + this.message;
    }
  };
} else {
  process.env.VUE_APP_ROOT_API = gladosConfig.chemvue_root_api;
}

process.env.VUE_APP_PUBLIC_PATH =
  process.env.NODE_ENV === "production"
    ? (process.env.SERVER_BASE_PATH ? process.env.SERVER_BASE_PATH + "/" : "") +
      "/v/"
    : "/";

module.exports = {
  indexPath: path.resolve(
    __dirname,
    "../src/glados/templates/glados/mainvue.html"
  ),
  //output.path
  outputDir: path.resolve(__dirname, "../src/glados/v"),
  //assetsSubDirectory
  assetsDir: "chemvue",
  //output.publicpath
  publicPath: process.env.VUE_APP_PUBLIC_PATH,
  css: {
    loaderOptions: {
      sass: {
        data: `@import "@/assets/sass/main.scss";`
      }
    }
  }
};
