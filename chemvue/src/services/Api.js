import axios from "axios";

export default () => {
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
};
