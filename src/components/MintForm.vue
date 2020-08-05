<template lang="pug">
v-card.pa-8
  v-form
    h2 Mint a Token
    v-text-field(label="Title") 
    v-textarea(label="Description") 
    v-file-input(label="Art File" type="file")
    v-btn Upload
</template>

<script>
export default {
  name: "MintForm",
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped></style>
