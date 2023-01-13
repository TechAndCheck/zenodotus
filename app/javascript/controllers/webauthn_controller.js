import { Controller } from '@hotwired/stimulus'
import {
  create,
  parseCreationOptionsFromJSON,
} from "@github/webauthn-json/browser-ponyfill";
import { get, post } from "@rails/request.js"


export default class extends Controller {
  static values = { input: String }
  static targets = [ "output" ]

  async connect() {
    if(navigator.credentials == undefined) {
      console.log("Webauthn not available. Are you on HTTPS?")
      return
      // Webauthn isn't supported, so we'll do stuff here eventually
    }

    const setup_response = await get("/setup_mfa/webauthn.json", {
      contentType: "application/json",
      responseKind: "json"
    })

    if (!setup_response.ok) {
      console.log ("Something went horribly wrong")
      return
    }

    const setup_response_body = await setup_response.text
    const optionsJson = JSON.parse(setup_response_body)
    const options = parseCreationOptionsFromJSON(optionsJson)

    const createResponse = await create(options);
    console.log(createResponse)

    const finishWebauthnResponse = await post("/setup_mfa/webauthn.json", {
      body: { publicKeyCredential: createResponse, nickname: "stuffthings" },
      contentType: "application/json",
      responseKind: "json"
    })

    const finishWebauthnResponseBody = await finishWebauthnResponse.text
    const finishedBodyJson = JSON.parse(finishWebauthnResponseBody)

    if(finishedBodyJson["registration_status"] == success) {
      this.outputTarget.textContent = "Success!"
    } else {
      this.outputTarget.textContent = "Failed"
    }
  }
}
