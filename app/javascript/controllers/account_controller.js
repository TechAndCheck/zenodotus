import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  /**
   *
   */
  toggleView({ params: { id } }) {
    const currentView = [...document.getElementsByClassName('settingsBlock')].filter((i) => i.getAttribute('hidden') == null)[0]
    const newView = document.getElementById(id)
    if (newView === currentView) {
      return
    }
    currentView.setAttribute('hidden', true)
    newView.removeAttribute('hidden')
  }

  /**
   * Resets form input elements. Waits a short period to ensure that inputs are not wiped before being sent to the backend
   */
  resetForm({ params }) {
    console.log("bi")
    setTimeout(() => [...document.getElementsByClassName(params.form)].forEach(inputElement => inputElement.value = ''), 100)
  }
}
