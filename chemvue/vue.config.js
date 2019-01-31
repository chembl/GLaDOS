const path = require("path");

module.exports = {
    indexPath: path.resolve(
        __dirname,
        "../src/glados/templates/glados/Unichem/substructureSimilaritySearch.html"
    ),
    //output.path
    outputDir: path.resolve(__dirname, "../src/glados/static"),
    //assetsSubDirectory
    assetsDir: "chemvue",
    //output.publicpath
    publicPath: process.env.NODE_ENV === 'production'
        ? "static/"
        : "/"
};
