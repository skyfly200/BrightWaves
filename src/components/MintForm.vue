<template lang="pug">
v-stepper(v-model='step')
  v-stepper-header
    v-stepper-step(:complete='step > 1' step='1') Upload Art
    v-divider
    v-stepper-step(:complete='step > 2' step='2') Upload Metadata
    v-divider
    v-stepper-step(step='3') Mint Token
  v-stepper-items
    v-stepper-content(step='1')
      v-card.mb-12(elevation="0")
        v-card-title Select Art
        v-card-text
          v-file-input(label="Art File" type="file")
        v-card-actions
          v-spacer
          v-btn(color='primary' @click='uploadArt') Upload To IPFS
    v-stepper-content(step='2')
      v-card.mb-12.metadata-fields(elevation="0")
        v-card-title Enter Metadata
        v-card-text
          v-autocomplete(:items="collections" label="Collection")
          v-text-field(label="Title") 
          v-text-field(label="Description")
        v-card-actions
          v-btn(@click="step = 1") Back
          v-spacer
          v-btn(color='primary' @click='step = 3') Upload To IPFS
    v-stepper-content(step='3')
      v-card.mb-12(elevation="0")
        v-card-title Mint a Token
        v-card-text
          h4 Gas Fees: 0.-----
          h4 Token Preview
          h4 Metadata Preview
        v-card-actions
          v-btn(@click="step = 2") Back
          v-spacer
          v-btn(color='primary' @click='step = 1') Mint
</template>

<script>
const pinataSDK = require("@pinata/sdk");
const { pinataKey, pinataSecret } = require("../../secrets.json");

export default {
  name: "MintForm",
  data: () => ({
    step: 1,
    collections: ["Kallidascopic", "Droplets"],
    pinata: null,
  }),
  mounted: async function() {
    //await this.$store.dispatch("initialize");
    this.getCollections();
    // load Pinata SDK
    this.pinata = pinataSDK(pinataKey, pinataSecret);
    this.pinata
      .testAuthentication()
      .then((result) => {
        //handle successful authentication here
        console.log(result);
      })
      .catch((err) => {
        //handle error here
        console.log(err);
      });
  },
  methods: {
    getCollections() {
      this.collections.push("Test");
    },
    uploadArt: async function() {
      // upload art to IPFS
      console.log("Uploading art to IPFS...");
      let formData = "";
      this.artHash = (await this.pinata.pinFileToIPFS(formData)).IpfsHash;
      this.step = 2;
    },
    uploadMetadata() {
      // const imageHash = (await pinata.pinFileToIPFS(artStream)).IpfsHash
      // const imageHash = ''
      // const animationHash = ''
      // const animationHash = await pinata.pinFileToIPFS(mp4Stream).IpfsHash
      // console.log('IPFS Hash: ')
      // console.log(imageHash)
      // set the creation time to now
      // let creationTime = 1546360800
      // // build the metadata object from the token data and IPFS hashes
      // let metadata = {
      //   name: 'Token ' + id,
      //   description:
      //     'A scattering of tiny boxes, Aranged in patterns ranging from mundane to magnificent.',
      //   external_url: EXTERNAL_URL_BASE + id,
      //   image: imageHash,
      //   image_data: art,
      //   background_color: '121212',
      //   animation_url: animationHash,
      //   attributes: [
      //     {
      //       display_type: 'date',
      //       trait_type: 'Created',
      //       value: creationTime,
      //     },
      //   ],
      // }
      // // log metadata to console
      // console.log('Metadata of token ' + id)
      // //console.log(metadata)
      // // upload metadata JSON object to IPFS
      // console.log('Writing metadata to IPFS')
      // const metadataHash = (await pinata.pinJSONToIPFS(metadata)).IpfsHash
      // console.log(metadataHash)
    },
    mintToken() {
      // use web3 with a browser provider to talk to deployed NFT contract and mint the token
    },
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="sass" scoped></style>
