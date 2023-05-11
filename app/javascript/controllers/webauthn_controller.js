import { Controller } from "@hotwired/stimulus"
import {
  create,
  parseCreationOptionsFromJSON,
} from "@github/webauthn-json/browser-ponyfill"
import { get, post } from "@rails/request.js"
import Lottie from "lottie-web"

export default class extends Controller {
  static values = { input: String }
  static targets = [ "lock", "webauthnContainer", "webauthnSetup", "nickname", "totpSetup", "totpSetupCode" ]

  async connect() {
    // Check if we're actually encrypting, if not, don't allow setup to continue.
    if(window.location.protocol != 'https:') {
      alert('Somehow you have visited an unencrypted version of this page, please contact us immediately to report this.')

      this.webauthnSetupTarget.remove()
      this.totpSetupTarget.remove()
      return
    }

    if(navigator.credentials == undefined) {
      alert('You are using an outdated or non-standard browser that does not support Webauthn, please click "Being App-Based Setup" below to continue.')

      this.webauthnSetupTarget.remove()
      return
    }

    if(navigator.userAgent.toLowerCase().indexOf('firefox') > -1){
      alert(
        'Unfortunately FireFox does not yet have full support for Webauthn, the technology we use for our two-factor authentication.\n' +
        'If you have a hardware key please click the "Begin Hardware Key Setup" button below, otherwise please click "Begin App-Based Setup" to continue')
    }

    this.lockAnimation = Lottie.loadAnimation({
      container: this.lockTarget, // the dom element that will contain the animation
      renderer: 'svg',
      autoplay: false,
      loop: false,
      path: '/lock-cpu-cyber-security.json' // the path to the animation json
    });
  }

  async beginWebauthnSetup() {
    if(navigator.credentials == undefined) {
      alert("Webauthn is not available. We only support modern browsers, please use Firefox, Safari, Chrome, or something similar")
      return
    }

    const setupResponse = await get("/setup_mfa/webauthn.json", {
      contentType: "application/json",
      responseKind: "json"
    })

    if (!setupResponse.ok) {
      alert("500 Error, please reload the page and try again")
      return
    }

    const setupResponseBody = await setupResponse.text
    const optionsJson = JSON.parse(setupResponseBody)

    const options = parseCreationOptionsFromJSON(optionsJson)
    let createResponse
    try {
      createResponse = await create(options);
    } catch(error) {
      console.log(error)
    }

    // Get nickname, giving a random one if blank
    let nickname = this.nicknameTarget.value
    if(nickname.length == 0){
      nickname = "webauthn_" + Math.floor(Math.random() * 500)
    }

    // NOTE FIX THIS NICKNAME
    const finishWebauthnResponse = await post("/setup_mfa/webauthn.json", {
      body: { publicKeyCredential: createResponse, nickname: nickname },
      contentType: "application/json",
      responseKind: "json"
    })

    const finishWebauthnResponseBody = await finishWebauthnResponse.text
    const finishedBodyJson = JSON.parse(finishWebauthnResponseBody)

    this.webauthnSetupTarget.classList.add("transition-opacity", "duration-150", "ease-out", "opacity-0")
    this.webauthnSetupTarget.remove()

    if(finishedBodyJson["registration_status"] == "success") {
      this.lockAnimation.play()
      await new Promise(r => setTimeout(r, 2000))

      this.loadRecoveryCodes()
    } else {
      this.lockTarget.classList.add("transition-opacity", "duration-150", "ease-out", "opacity-0")
      await new Promise(r => setTimeout(r, 500))

      this.lockAnimation.destroy()
      this.lockTarget.innerHTML = finishedBodyJson["errorPartial"]
      this.lockTarget.classList.replace("opacity-0", "opacity-100")
    }
  }

  async beginTotpSetup() {
    const setupResponse = await get("/setup_mfa/totp.json", {
      contentType: "application/json",
      responseKind: "json"
    })

    if (!setupResponse.ok) {
      alert("500 Error, please reload the page and try again")
      return
    }

    const setupResponseBody = await setupResponse.text
    const setupResponseJson = JSON.parse(setupResponseBody)


    this.webauthnContainerTarget.innerHTML = setupResponseJson["partial"]
  }

  async finishTotpSetup() {
    const totpSetupCode = this.totpSetupCodeTarget.value

    if(!totpSetupCode.match(/^\d{6}$/)) {
      alert("The TOTP code must be a six digit number only.")
    }

    const setupResponse = await post("/setup_mfa/totp.json", {
      body: { totp_setup_code: totpSetupCode },
      contentType: "application/json",
      responseKind: "json"
    })

    if (!setupResponse.ok) {
      alert("500 Error, please reload the page and try again")
      return
    }

    this.loadRecoveryCodes()
  }

  async loadRecoveryCodes() {
    const setupResponse = await get("/setup_mfa/webauthn/setup_recovery_codes.json", {
      contentType: "application/json",
      responseKind: "json"
    })

    if (!setupResponse.ok) {
      alert("500 Error, please reload the page and try again")
      return
    }

    const setupResponseBody = await setupResponse.text
    const setupResponseJson = JSON.parse(setupResponseBody)

    if(this.hasLockTarget){
      this.lockTarget.classList.add("transition-opacity", "duration-150", "ease-out", "opacity-0")
      await new Promise(r => setTimeout(r, 500))

      this.lockAnimation.destroy()
    }

    // If there's an error returned we just skipped past the recovery section and move on
    if(setupResponseJson["errorPartial"] != undefined) {
      this.finishSetup()
      return
    }

    this.webauthnContainerTarget.innerHTML = setupResponseJson["recoveryCodePartial"]
  }

  finishSetup() {
    // We need to remove the codes from the DOM so the back button doesn't allow the codes to be
    // retrieved later on
    this.webauthnContainerTarget.classList.remove("opacity-100")
    this.webauthnContainerTarget.classList.add("transition-opacity", "duration-150", "ease-out", "opacity-0")
    this.webauthnContainerTarget.destroy
    Turbo.visit("/")
  }
}
