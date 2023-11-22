import { Controller } from '@hotwired/stimulus'
import { get, post } from "@rails/request.js"

export default class extends Controller {
  static targets = [ "checkAll" ]

  initialize() {
    console.log("Connected")
  }

  clickAllScrapes(event) {
    const checkboxes = document.getElementsByName('sites_selected[]')
    checkboxes.forEach(function (checkbox, _) {
      checkbox.checked = event.currentTarget.checked;
    })
  }

  // async startScrape(event) {
  //   event.preventDefault()

  //   const scrapeStartResponse = await post("/admin/web_scrapes/" + event.currentTarget.id + "/scrape.json", {
  //     body: {},
  //     contentType: "application/json",
  //     responseKind: "json"
  //   })

  //   const scrapeStartResponseBody = await scrapeStartResponse.text
  //   const scrapeStartResponseBodyJson = JSON.parse(scrapeStartResponseBody)

  //   Turbo.visit('/admin/web_scrapes/', { action: "replace", frame: "web_scrapes_list" })
  // }
}
