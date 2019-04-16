import axios from "axios";

export default class RestAPI {
  getSimilarity() {
    let path = `${process.env.VUE_APP_ROOT_API}/${
      process.env.VUE_APP_SERVER_BASE_PATH
    }glados_api/chembl/unichem`;
    console.log(path);
    return axios.create({
      baseURL: path,
      withCredentials: false,
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json"
      }
    });
  }

  getImageFromSmile() {
    let path = `https://www.ebi.ac.uk/chembl/api/utils/smiles2svg`;
    return axios.create({
      baseURL: path,
      withCredentials: false
    });
  }
}
