import axios from "axios";

export default class RestAPI {
  getGLaDOSAPI() {
    let path = `${process.env.VUE_APP_ROOT_API}/${
      process.env.VUE_APP_SERVER_BASE_PATH
    }glados_api/chembl/unichem`;
    return axios.create({
      baseURL: path,
      withCredentials: false,
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json"
      }
    });
  }

  getBeakerAPI() {
    let path = `https://www.ebi.ac.uk/chembl/api/utils`;
    return axios.create({
      baseURL: path,
      withCredentials: false
    });
  }
}
