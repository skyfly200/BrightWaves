<template lang="pug">
v-stepper(v-model='step')
  v-stepper-header
    v-stepper-step(:complete='step > 1' step='1') Add Art
    v-divider
    v-stepper-step(:complete='step > 2' step='2') Upload Metadata
    v-divider
    v-stepper-step(step='3') Mint Token
    v-divider
    v-stepper-step(step='4') Done
  v-stepper-items
    v-stepper-content(step='1')
      v-card.mb-12(elevation="0")
        v-card-title Add Your Art
        v-card-text
          v-file-input(v-if="newUpload" label="Art File" type="file")#art-file
          v-text-field(v-else label="IPFS Hash" v-model="artHash")
          h4 {{ newUpload ? "Already have an IPFS Hash?" : "Need to upload a file to IPFS?"}}
          v-btn(color="secondary" @click="newUpload = !newUpload") {{ newUpload ? "Enter an IPFS Hash" : "Upload A File" }}
        v-card-actions
          v-btn(@click="") Reset
          v-spacer
          v-btn(color='primary' @click='uploadArt') {{ newUpload ? "Upload To IPFS" : "Next"}}
    v-stepper-content(step='2')
      v-card.mb-12.metadata-fields(elevation="0")
        v-card-title Enter Metadata
        v-card-text
          v-autocomplete(:items="collections" label="Collection" v-model="collection")
          v-text-field(label="Title" v-model="title")
          v-text-field(label="Description" v-model="description")
          v-text-field(label="Background Color" v-model="bkgColor")
          v-text-field(label="External URL" v-model="externalURL")
        v-card-actions
          v-btn(@click="step = 1") Back
          v-spacer
          v-btn(color='primary' @click='uploadMetadata') Upload To IPFS
    v-stepper-content(step='3')
      v-card.mb-12(elevation="0")
        v-card-title Mint Preview
        v-card-text
          h4 Token Art
          v-img(:src="'https://gateway.pinata.cloud/ipfs/' + artHash")
          h4 Token Metadata
          p {{ metadata }}
        v-card-actions
          v-btn(@click="step = 2") Back
          v-spacer
          v-btn(color='primary' @click='mintToken') Mint
    v-stepper-content(step='4')
      v-card.mb-12(elevation="0")
        v-card-title Token Minted
        v-card-text
          h4 TokenId: {{ tokenId }}
          h4 View Token on OpenSea
          h4 View TX on etherscan
        v-card-actions
          v-spacer
          v-btn(color='primary' @click='step = 1') Mint Another
</template>

<script>
const { PINATA_API_KEY, PINATA_API_SECRET } = require("../../secrets.json");

export default {
  name: "MintForm",
  data: () => ({
    step: 1,
    newUpload: true,
    title: "",
    description: "",
    collection: null,
    bkgColor: "FFFFFF",
    externalURL: "https://skylerfly.com/",
    collections: ["Kallidascopic", "Droplets"],
    artResp: null,
    artHash: null,
    metadataResp: null,
    tokenId: null,
  }),
  mounted: async function() {
    //await this.$store.dispatch("initialize");
    this.getCollections();
  },
  methods: {
    getCollections() {
      this.collections.push("Test");
    },
    uploadArt: async function() {
      if (this.newUpload) {
        // upload art to IPFS
        console.log("Uploading art to IPFS...");
        const selectedFile = document.getElementById("art-file").files[0];
        // build form data with any valid readStream source
        let formData = new FormData();
        formData.append("file", selectedFile);
        this.artResp = await this.$http.post(
          `https://api.pinata.cloud/pinning/pinFileToIPFS`,
          formData,
          {
            maxContentLength: "Infinity", //this is needed to prevent axios from erroring out with large files
            headers: {
              "Content-Type": `multipart/form-data; boundary=${formData._boundary}`,
              pinata_api_key: PINATA_API_KEY,
              pinata_secret_api_key: PINATA_API_SECRET,
            },
          }
        );
        this.artHash = this.artResp.data.IpfsHash;
        console.log(this.artResp.data);
      } else {
        console.log(this.artHash);
      }
      this.step = 2;
    },
    uploadMetadata: async function() {
      // build the metadata object from the token data and IPFS hashes
      let metadata = {
        name: this.title,
        description: this.description,
        external_url: this.externalURL,
        image: this.artHash,
        background_color: this.bkgColor,
        attributes: [
          {
            display_type: "date",
            trait_type: "Created",
            value: parseInt((new Date().getTime() / 1000).toFixed(0)),
          },
          {
            trait_type: "Collection",
            value: this.collection,
          },
        ],
      };
      // log metadata to console
      console.log("Metadata of token:");
      console.log(metadata);
      // upload metadata JSON object to IPFS
      console.log("Writing metadata to IPFS");
      this.metadataResp = await this.$http.post(
        `https://api.pinata.cloud/pinning/pinJSONToIPFS`,
        metadata,
        {
          maxContentLength: "Infinity", //this is needed to prevent axios from erroring out with large files
          headers: {
            "Content-Type": `application/json`,
            pinata_api_key: PINATA_API_KEY,
            pinata_secret_api_key: PINATA_API_SECRET,
          },
        }
      );
      console.log(this.metadataResp.data);
      this.step = 3;
    },
    mintToken() {
      // use web3 with a browser provider to talk to deployed NFT contract and mint the token
      this.step = 4;
    },
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="sass" scoped></style>
