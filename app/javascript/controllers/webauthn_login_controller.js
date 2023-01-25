import { Controller } from '@hotwired/stimulus'
import { get as webauthnGet, parseRequestOptionsFromJSON } from '@github/webauthn-json/browser-ponyfill'
import { get, post } from "@rails/request.js"
import Lottie from "lottie-web"

export default class extends Controller {
  static values = {}
  static targets = [ "output", "lock", "authenicateButton" ]

  async connect() {
    // Check if we're actually encrypting, if not, don't allow setup to continue.
    if(window.location.protocol != 'https:') {
      this.outputTarget.textContent = "Somehow you've visited an unencrypted version of this page, please contact us immediately to report this."

      this.webauthnSetupTarget.remove()
      this.totpSetupTarget.remove()
      return
    }

    if(navigator.credentials == undefined) {
      this.outputTarget.textContent = 'You are using an outdated or non-standard browser that does not support Webauthn, please click "Being App-Based Setup" below to continue.'

      this.webauthnSetupTarget.remove()
      return
    }

    this.lockAnimation = Lottie.loadAnimation({
      container: this.lockTarget, // the dom element that will contain the animation
      renderer: 'svg',
      autoplay: false,
      loop: false,
      path: '/lock-cpu-cyber-security.json' // the path to the animation json
    });
    this.lockAnimation.setDirection(-1)
    this.lockAnimation.goToAndStop(83, true)
  }

  async authenticateWebauthn() {
    if(navigator.credentials == undefined) {
      alert("Webauthn is not available. We only support modern browsers, please use Firefox, Safari, Chrome, or something similar")
      return
    }

    const setup_response = await get("/users/sign_in/mfa/webauthn.json", {
      contentType: "application/json",
      responseKind: "json"
    })

    if (!setup_response.ok) {
      alert("500 Error, please reload the page and try again")
      return
    }

    const setup_response_body = await setup_response.text
    const optionsJson = JSON.parse(setup_response_body)
    const options = parseRequestOptionsFromJSON(optionsJson)

    const getResponse = await webauthnGet(options);

    const finishWebauthnResponse = await post("/users/sign_in/mfa/webauthn.json", {
      body: { publicKeyCredential: getResponse, nickname: "stuffthings" },
      contentType: "application/json",
      responseKind: "json"
    })

    const finishWebauthnResponseBody = await finishWebauthnResponse.text
    const finishedBodyJson = JSON.parse(finishWebauthnResponseBody)

    if(finishedBodyJson["authentication_status"] == "success") {
      this.authenicateButtonTarget.textContent = "Logging In..."
      this.lockAnimation.play()
      await new Promise(r => setTimeout(r, 2000))

      window.location = "/"
    } else {
      this.lockTarget.innerHTML = finishedBodyJson["errorPartial"] + this.lockTarget.innerHTML
      this.lockTarget.firstChild.classList.add("transition-opacity", "duration-500", "ease-out")
      this.lockTarget.firstChild.classList.replace("opacity-0", "opacity-100")
    }
  }
}
