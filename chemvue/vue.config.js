const path = require("path");

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
    publicPath: process.env.NODE_ENV === 'production'
        ? "v/"
        : "/"
};
