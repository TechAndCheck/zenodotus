import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = [ "search-id" ]

  onPostSend() {
    // Add an overlay to the page while we're processing
    const loader = document.getElementById('loader')
    if (loader !== null) {
      loader.classList.remove('hidden')
    }
  }

  onPostSuccess(event) {
    // Remove the loader overlay
    const loader = document.getElementById('loader')
    if (loader !== null) {
      loader.classList.add('hidden')
    }

    // Reset the form so it can be used again.
    this.element.reset()

    // We pass back the search id in the headers
    let searchId = event.detail.fetchResponse.response.headers.get("X-search-id")
    // This adds the search id to the url so that reloads work
    let newUrl = new URL(window.location.href)
    let params = new URLSearchParams(newUrl.search)
    params.set('q_id', searchId)
    newUrl.search = params
    newUrl = newUrl.toString()
    history.pushState({}, null, newUrl)
  }
}
