import Vue from 'vue'
import Vuex from 'vuex'
import Web3 from 'web3'

const { address, abi } = require('../contract-data.json')

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    currentAccount: '',
    web3Status: 'loading',
    web3: null,
    contract: null,
  },
  mutations: {
    setContract(state, payload) {
      state.contract = payload
    },
    setWeb3(state, instance) {
      state.web3 = instance
    },
    setWeb3Status(state, status) {
      state.web3Status = status
    },
    setAccount(state, address) {
      state.currentAccount = address
    },
  },
  actions: {
    async initialize(context) {
      await context.dispatch('loadWeb3')
      await context.dispatch('loadAccount')
      await context.dispatch('registerContracts')
    },
    loadWeb3(context) {
      return new Promise((resolve) => {
        if (window.ethereum) {
          context.commit('setWeb3', new Web3(window.ethereum))
          try {
            // Request account access if needed
            window.ethereum.enable().then(() => {
              context.commit('setWeb3Status', 'active')
              resolve()
            })
          } catch (error) {
            context.commit('setWeb3Status', 'denied')
            resolve()
          }
        } else if (window.web3) {
          // Legacy dapp browsers...
          context.commit('setWeb3', new Web3(window.web3.currentProvider))
          context.commit('setWeb3Status', 'active')
          resolve()
        } else {
          // Non-dapp browsers...
          context.commit('setWeb3Status', 'inactive')
          resolve()
        }
      })
    },
    loadAccount(context) {
      return new Promise((resolve, reject) => {
        const web3 = context.state.web3
        if (web3 !== null) {
          web3.eth.getAccounts((err, resp) => {
            if (err) reject(err)
            else {
              context.commit('setAccount', resp[0])
              resolve(resp[0])
            }
          })
        } else reject()
      })
    },
    registerContracts(context) {
      return new Promise((resolve, reject) => {
        const web3 = context.state.web3
        if (web3 !== null) {
          context.commit('setContract', new web3.eth.Contract(abi, address))
          resolve()
        } else reject()
      })
    },
  },
  getters: {
    currentAccount: (state) => {
      return state.currentAccount
    },
    web3Status: (state) => {
      return state.web3Status
    },
  },
})

export default store
