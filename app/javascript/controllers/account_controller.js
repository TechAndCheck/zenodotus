import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    const url = window.location.href
    console.log('load', url)
    if (url.includes('text_search')) {
      document.getElementById('accountSettings').hidden = true
      document.getElementById('textSearchHistory').removeAttribute('hidden')
      console.log('accountSettings.hidden is now', document.getElementById('accountSettings').hidden)
      console.log('textSearchHistory.hidden is now', document.getElementById('textSearchHistory').hidden)
      currentView = "textSearchHistory"
    }
    else if (url.includes("image_search")) {
      document.getElementById("accountSettings").hidden = true;
      document.getElementById("imageSearchHistory").removeAttribute("hidden");
      currentView = "imageSearchHistory";
    }
  }

  /**
   * Toggle the section visible on the accounts page
   */
  toggleView({ params: { id } }) {
    const currentView = [...document.getElementsByClassName('settingsBlock')].filter((i) => i.getAttribute('hidden') == null)[0]
    const newView = document.getElementById(id)
    if (newView === currentView) {
      return
    }
    currentView.setAttribute('hidden', true) // The "true" here is superfluous, but this is shorter than creating an empty attribute
    newView.removeAttribute('hidden')
  }

  /**
   * Resets form input elements. Waits a short period to ensure that inputs are not wiped before being sent to the backend
   */
  resetForm({ params }) {
    setTimeout(() => [...document.getElementsByClassName(params.form)].forEach(inputElement => inputElement.value = ''), 100)
  }
}
