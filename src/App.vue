<template>
  <v-app>
    <v-app-bar app color="primary" dark>
      <div class="d-flex align-center">
        <v-toolbar-title>BrightWaves NFT Minter</v-toolbar-title>
      </div>

      <v-spacer></v-spacer>

      <v-btn
        href="https://github.com/skyfly200/BrightWaves"
        target="_blank"
        text
      >
        <span class="mr-2">View Source</span>
        <v-icon>mdi-open-in-new</v-icon>
      </v-btn>
    </v-app-bar>

    <v-main>
      <v-container>
        <MintForm />
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
import MintForm from "./components/MintForm";

export default {
  name: "App",

  components: {
    MintForm,
  },

  data: () => ({
    //
  }),
};
</script>
