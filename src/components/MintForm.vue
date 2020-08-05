<template lang="pug">
v-stepper(v-model='e1')
  v-stepper-header
    v-stepper-step(:complete='e1 > 1' step='1') Upload Art
    v-divider
    v-stepper-step(:complete='e1 > 2' step='2') Upload Metadata
    v-divider
    v-stepper-step(step='3') Mint Token
  v-stepper-items
    v-stepper-content(step='1')
      v-card.mb-12(color='grey lighten-1' height='200px')
        h2 Select Art
        v-file-input(label="Art File" type="file")
      v-btn(color='primary' @click='e1 = 2') Upload To IPFS
      v-btn(text='') Cancel
    v-stepper-content(step='2')
      v-card.mb-12(color='grey lighten-1' height='200px').metadata-fields
        h2 Enter Metadata
        v-text-field(label="Title") 
        v-text-field(label="Description")
        v-autocomplete(:items="collections" label="Collection").collection-select
      v-btn(color='primary' @click='e1 = 3') Upload To IPFS
      v-btn(text='') Cancel
    v-stepper-content(step='3')
      v-card.mb-12(color='grey lighten-1' height='200px')
        h2 Mint a Token
        h4 Gas Fees: 0.-----
      v-btn(color='primary' @click='e1 = 1') Mint
      v-btn(text='') Cancel
</template>

<script>
export default {
  name: "MintForm",
  data: () => ({
    e1: 1,
    collections: ["Kallidascopic", "Droplets"],
  }),
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="sass" scoped>
.metadata-fields
  height: 100%
</style>
