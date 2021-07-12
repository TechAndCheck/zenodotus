import { Controller } from 'stimulus'

export default class extends Controller {
  onPostSend() {
    // Add an overlay to the page while we're processing
    const loader = document.getElementById('loader')
    if (loader !== null) {
      loader.classList.remove('hidden')
    }
  }

  onPostSuccess() {
    // Remove the loader overlay
    const loader = document.getElementById('loader')
    if (loader !== null) {
      loader.classList.add('hidden')
    }

    // Reset the form so it can be used again.
    this.element.reset()
  }
}
